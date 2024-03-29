import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'account_event.dart';
part 'account_state.dart';

const String subscriptionId = 'subscription1';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late final InAppPurchase _iap;
  bool available = false;
  final List<PurchaseDetails> _purchases = [];
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Set<String> ids = {subscriptionId};
  AccountBloc() : super(AccountInitial()) {
    on<InitAccountEvent>((event, emit) async {
      // await _initialize();
    });
    on<CheckAccountEvent>((event, emit) {
      // _checkSubscriptionStatus();
      emit(AccountNonSubscribed());
    });

    on<SubscriptionEvent>((event, emit) async {
      await subscribe();
    });
  }

  Future<void> _initialize() async {
    _iap = InAppPurchase.instance;
    available = await _iap.isAvailable();
    if(!available) {
      return;
    }

    await _getProductDetails();
    _subscription = _iap.purchaseStream.listen((purchaseDetailsList) async {

      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          // Handle pending purchase
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            // Handle error
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            _purchases.addAll(purchaseDetailsList);
            _checkSubscriptionStatus();
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await _iap.completePurchase(purchaseDetails);
          }
        }
      });
    },
        onDone: (){
          _subscription?.cancel();
        });
    await _iap.restorePurchases();
  }

  Future<void> subscribe() async {
    if (available) {
      await _getProductDetails();
      if(_products.isEmpty) {
        return;
      }

      final ProductDetails product = _products.firstWhere((product) => product.id == subscriptionId, orElse: () => null as ProductDetails);
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
          return;
    }
  }

  Future<ProductDetails?> _getProductDetails() async {
    final ProductDetailsResponse response =
    await _iap.queryProductDetails(ids);
    _products = response.productDetails;
    return null;
  }

  void _checkSubscriptionStatus() {
    bool isSubscribed = _purchases.any((purchase) =>
    purchase.productID == subscriptionId &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored));

    if(isSubscribed) {
      emit(AccountSubscribed());
    } else {
      emit(AccountNonSubscribed());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
