part of 'reorder_item_animation_bloc.dart';

@immutable
abstract class ReorderItemAnimationEvent {}

class ReorderEvent extends ReorderItemAnimationEvent{}
class ReorderEventEnd extends ReorderItemAnimationEvent{}