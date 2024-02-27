part of 'reorder_item_animation_bloc.dart';

@immutable
abstract class ReorderItemAnimationState {}

class ReorderItemAnimationInitial extends ReorderItemAnimationState {}
class ReorderItemAnimationOccurState extends ReorderItemAnimationState {}
class ReorderItemAnimationEndState extends ReorderItemAnimationState {}
