import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:combinators/services/crud/entity/group_entity.dart';
import 'package:flutter/foundation.dart';

part 'combination_item_crud_event.dart';

part 'combination_item_crud_state.dart';

class CombinationGroupDbBloc
    extends Bloc<CombinationGroupDbEvent, CombinationGroupDbState> {
  final CombinationItemRepository _combinationItemRepository;

  CombinationGroupDbBloc(this._combinationItemRepository)
      : super(const CombinationItemDbInitialState()) {
    on<CombinationGroupLoadEvent>(
      (event, emit) async {
        emit(const CombinationItemDbInitialState());
        List<DatabaseGroup> groups =
            await _combinationItemRepository.getAllGroups();
        emit(CollectionGroupLoadedState(entities: groups));
      },
      // transformer: droppable(),
    );

    on<CombinationGroupCreateEvent>(
      (event, emit) async {
        List<DatabaseGroup> updatedGroup =
            await _combinationItemRepository.createGroup(name: event.groupName);
        emit(CollectionGroupLoadedState(entities: updatedGroup));
      },
      transformer: droppable(),
    );

    on<CombinationGroupReorderEvent>(
      (event, emit) async {
        List<DatabaseGroup> updatedEntities =
            await _combinationItemRepository.updateGroupKey(
                groupList: event.items,
                oldIndex: event.oldIndex,
                newIndex: event.newIndex);

        emit(CollectionGroupLoadedState(entities: updatedEntities));
      },
      transformer: sequential(),
    );

    on<CombinationGroupRenameEvent>(
      (event, emit) async {
        await _combinationItemRepository.updateGroupName(
            id: event.id, newName: event.newGroupName);
      },
      transformer: droppable(),
    );

    on<CombinationGroupDeleteEvent>(
      (event, emit) async {
        await _combinationItemRepository.deleteGroup(id: event.groupId);
        List<DatabaseGroup> groups =
            await _combinationItemRepository.getAllGroups();
        emit(CollectionGroupLoadedState(entities: groups));
      },
      transformer: droppable(),
    );
  }
}
