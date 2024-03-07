import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountInitial()) {
    on<CheckAccountEvent>((event, emit) {
      emit(const AccountInitial());
    });
  }
}
