part of 'account_bloc.dart';

@immutable
abstract class AccountState {
  final bool isLoading;
  final String loadingText;
  final bool isSubscribing;

  const AccountState({
    this.isLoading = false,
    this.loadingText = 'Please wait a moment',
    this.isSubscribing = false,
  });
}

class AccountInitial extends AccountState {
  const AccountInitial();
}
