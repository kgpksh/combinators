part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class CheckSubscription extends SubscriptionEvent {}