import 'package:bloc/bloc.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:combinators/services/crud/entity/group_entity.dart';
import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:flutter/foundation.dart';

part 'combination_item_crud_event.dart';

part 'combination_item_crud_state.dart';

class CombinationItemDbBloc
    extends Bloc<CombinationItemDbEvent, CombinationItemDbState> {
  final CombinationItemRepository _combinationItemRepository;

  CombinationItemDbBloc(this._combinationItemRepository)
      : super(const CombinationItemDbInitialState()) {
    on<CombinationGroupLoadEvent>((event, emit) async {
      emit(const CombinationItemDbInitialState());
      List<DatabaseGroup> groups =
          await _combinationItemRepository.getAllGroups();
      emit(CollectionGroupLoadedState(entities: groups));
    });

    on<CombinationGroupCreateEvent>((event, emit) async {
      List<DatabaseGroup> updatedGroup =
          await _combinationItemRepository.createGroup(name: event.groupName);
      emit(CollectionGroupLoadedState(entities: updatedGroup));
    });

    on<CombinationGroupReorderEvent>((event, emit) async {
      List<ItemBaseEntity> updatedEntities =
          await _combinationItemRepository.updateEntityKey(
              tableName: event.tableName,
              items: event.items,
              oldIndex: event.oldIndex,
              newIndex: event.newIndex);

      emit(CollectionGroupLoadedState(entities: updatedEntities));
    });

    on<CombinationGroupRenameEvent>((event, emit) async {
      await _combinationItemRepository.updateGroupName(
          id: event.id, newName: event.newGroupName);
    });

    on<CombinationGroupDeleteEvent>((event, emit) async {
      await _combinationItemRepository.deleteGroup(id: event.groupId);
      List<DatabaseGroup> groups =
          await _combinationItemRepository.getAllGroups();
      emit(CollectionGroupLoadedState(entities: groups));
    });
  }
}
