import 'package:flutter/material.dart';

typedef ListItemWidgetBuilder<ItemBaseEntity> = Widget Function(
    BuildContext context, ItemBaseEntity item);

class CachedReorderableListView<ItemBaseEntity> extends StatefulWidget {
  const CachedReorderableListView({required this.list,
    required this.itemBuilder,
    required this.onReorder,
    required this.scrollDirection,
    super.key});

  final List<ItemBaseEntity> list;
  final ListItemWidgetBuilder<ItemBaseEntity> itemBuilder;
  final ReorderCallback onReorder;
  final Axis scrollDirection;

  @override
  CachedReorderableListViewState<ItemBaseEntity> createState() =>
      CachedReorderableListViewState<ItemBaseEntity>();
}

class CachedReorderableListViewState<ItemBaseEntity>
    extends State<CachedReorderableListView<ItemBaseEntity>> {
  late List<ItemBaseEntity> list;

  @override
  void initState() {
    list = [...widget.list];
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CachedReorderableListView<ItemBaseEntity> oldWidget) {
    if (widget.list != oldWidget.list) {
      list = [...widget.list];
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateList(List<ItemBaseEntity> value) {
    setState(() {
      list = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollDirection: widget.scrollDirection,
      proxyDecorator: (Widget child, int index, _) {
        return Container(
          // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
          color: Theme
              .of(context)
              .secondaryHeaderColor,
          child: child,
        );
      },
      itemCount: list.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, list[index]),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);
        });

        widget.onReorder(oldIndex, newIndex);
      },
    );
  }
}
