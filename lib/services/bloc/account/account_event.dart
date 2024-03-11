part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class InitAccountEvent extends AccountEvent {}
class CheckAccountEvent extends AccountEvent{}
class SubscriptionEvent extends AccountEvent{}