part of 'time_management_cubit.dart';

@immutable
abstract class TimeManagementState {
  final DateTime nextResetTime;
  final int currentRerollCount;

  String formattedDate() {
    return DateFormat('HH:mm').format(nextResetTime);
  }

  const TimeManagementState({required this.nextResetTime, required this.currentRerollCount});
}

class TimeManagementInitial extends TimeManagementState {
  const TimeManagementInitial({required super.nextResetTime, required super.currentRerollCount});
}

class TimeManagementCurrentState extends TimeManagementState {
  const TimeManagementCurrentState({required super.nextResetTime, required super.currentRerollCount});
}