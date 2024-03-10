part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountSubscribed extends AccountState{}

class AccountNonSubscribed extends AccountState {}