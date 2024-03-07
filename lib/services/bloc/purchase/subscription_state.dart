part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionActive extends SubscriptionState {}

class SubscriptionInactive extends SubscriptionState {}
