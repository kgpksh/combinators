import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

part 'time_management_state.dart';

const String nextResetTime = 'nextResetTime';
const String currentRerollCount = 'currentRerollCount';
const int maxRerollCount = 30;
const Duration resetTimeHourUnit = Duration(hours: 1);

class TimeManagementCubit extends HydratedCubit<TimeManagementState> {
  TimeManagementCubit()
      : super(
          TimeManagementInitial(
            nextResetTime: DateTime(1, 1, 1, 0, 0, 0, 0, 0),
            currentRerollCount: maxRerollCount,
          ),
        );

  void forceResetRerollCount() {
    final now = DateTime.now();
    emit(
      TimeManagementCurrentState(
        currentRerollCount: maxRerollCount,
        nextResetTime: now.add(
          resetTimeHourUnit,
        ),
      ),
    );
  }

  void decreaseRerollCount() {
    emitCheckResetTime();
    if (state.currentRerollCount > 0) {
      emit(TimeManagementCurrentState(
        currentRerollCount: state.currentRerollCount - 1,
        nextResetTime: state.nextResetTime,
      ),);
    }
  }

  void emitCheckResetTime() {
    DateTime target = state.nextResetTime;
    final now = DateTime.now();
    if (now.isAfter(target)) {
      emit(
        TimeManagementCurrentState(
          currentRerollCount: maxRerollCount,
          nextResetTime: now.add(
            resetTimeHourUnit,
          ),
        ),
      );
    }
  }

  @override
  TimeManagementState? fromJson(Map<String, dynamic> json) {
    return TimeManagementCurrentState(
      nextResetTime: DateTime.parse(json['nextResetTime']),
      currentRerollCount: json['currentRerollCount'] as int,
    );
  }

  @override
  Map<String, dynamic>? toJson(TimeManagementState state) => {
    'nextResetTime': state.nextResetTime.toIso8601String(),
    'currentRerollCount': state.currentRerollCount,
  };
}
