import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial());

  @override
  Stream<SubscriptionState> mapEventToState(SubscriptionEvent event) async* {
    if (event is CheckSubscription) {
      // in_app_purchase 라이브러리를 사용하여 구독 상태를 확인합니다.
      // 이 예제에서는 구독 상태를 확인하는 코드가 생략되었습니다.
      bool isSubscribed = false; // 구독 상태를 확인하는 실제 코드로 변경해야 합니다.

      if (isSubscribed) {
        yield SubscriptionActive();
      } else {
        yield SubscriptionInactive();
      }
    }
  }
}