import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:combinators/services/crud/entity/category_entity.dart';
import 'package:meta/meta.dart';

part 'combination_event.dart';

part 'combination_state.dart';

class CombinationBloc extends Bloc<CombinationEvent, CombinationState> {
  final CombinationItemRepository _combinationItemRepository;

  CombinationBloc(this._combinationItemRepository)
      : super(CombinationInitial()) {
    on<CombinationEvent>((event, emit) {});

    on<CombinationCategoryCreateEvent>(
      (event, emit) async {
        await _combinationItemRepository.createCategory(
            groupId: event.groupId, name: event.name);
        List<DatabaseCategory> combinations = await _combinationItemRepository
            .getCombinationDatas(groupId: event.groupId);

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );

    on<CombinationPageLoadEvent>(
      (event, emit) async {
        emit(CombinationInitial());
        List<DatabaseCategory> combinations = await _combinationItemRepository
            .getCombinationDatas(groupId: event.groupId);

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: restartable(),
    );

    on<CombinationCategoryReorderEvent>((event, emit) async {
      List<DatabaseCategory> updatedCombinations =
          await _combinationItemRepository.updateCategoryKey(
              combinationList: event.items,
              oldIndex: event.oldIndex,
              newIndex: event.newIndex,
              groupId: event.groupId);

      emit(CombinationPageLoadedState(combinationData: updatedCombinations));
    });

    on<CombinationItemCreateEvent>(
      (event, emit) async {
        await _combinationItemRepository.createItem(
            categoryId: event.categoryId, name: event.name);
        List<DatabaseCategory> combinations = await _combinationItemRepository
            .getCombinationDatas(groupId: event.groupId);

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );

    on<CombinationCategoryRenameEvent>(
      (event, emit) async {
        List<DatabaseCategory> combinations =
            await _combinationItemRepository.updateCategoryName(
          categoryList: event.categoryList,
          id: event.id,
          newName: event.newCategoryName,
        );

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );

    on<CombinationCategoryDeleteEvent>(
      (event, emit) async {
        List<DatabaseCategory> combinations =
            await _combinationItemRepository.deleteCategory(
          categoryList: event.categoryList,
          id: event.categoryId,
        );

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );

    on<CombinationItemRenameEvent>(
      (event, emit) async {
        List<DatabaseCategory> combinations =
            await _combinationItemRepository.updateItemName(
          categoryList: event.categoryList,
          categoryId: event.categoryId,
          itemIndex: event.itemIndex,
          newName: event.newName,
        );

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );

    on<CombinationItemDeleteEvent>(
      (event, emit) async {
        List<DatabaseCategory> combinations =
            await _combinationItemRepository.deleteItem(
          categoryList: event.categoryList,
          categoryId: event.categoryId,
          itemIndex: event.itemIndex,
        );

        emit(CombinationPageLoadedState(combinationData: combinations));
      },
      transformer: droppable(),
    );
  }
}
