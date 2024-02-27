import 'package:combinators/services/bloc/app_info/app_info_bloc.dart';
import 'package:combinators/services/bloc/crud/combination_item_crud_bloc.dart';
import 'package:combinators/services/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:combinators/services/bloc/reorder_item_animation/reorder_item_animation_bloc.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:combinators/services/crud/entity/item_base_entity.dart';
import 'package:combinators/views/home/cached_reorderable_list_view.dart';
import 'package:combinators/views/home/drawers/open_source_license_list_view.dart';
import 'package:combinators/views/combine/combination.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/bloc/account/account_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AppInfoBloc>().add(CallAppInfoEvent());
    context.read<CombinationItemDbBloc>().add(CombinationGroupLoadEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('All groups'),
      ),
      drawer: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Drawer(
            child: ListView(
              children: <Widget>[
                BlocBuilder<AppInfoBloc, AppInfoState>(
                    builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Text(
                      state.appName,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
                Visibility(
                  visible: !state.isSubscribing,
                  child: const ListTile(
                    leading: Icon(Icons.do_disturb_on_outlined),
                    title: Text('Subscribe and remove Ads'),
                  ),
                ),
                Visibility(
                  visible: state.isSubscribing,
                  child: const ColoredBox(
                    color: Colors.green,
                    child: ListTile(
                      leading: Icon(Icons.check),
                      title: Text('You are SUBSCRIBING'),
                    ),
                  ),
                ),
                ListTile(
                    title: const Text('Open Source Licenses'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OssLicensesListPage()));
                    }),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text('Dark Mode'),
                      BlocBuilder<DarkModeBloc, bool>(
                        builder: (context, state) {
                          return Switch(
                              value: state,
                              onChanged: (value) {
                                context.read<DarkModeBloc>().add(
                                    ChangeDarkModeEvent(isDarkMode: value));
                              });
                        },
                      )
                    ],
                  ),
                ),
                BlocBuilder<AppInfoBloc, AppInfoState>(
                    builder: (context, state) {
                  return Text('Version : ${state.appVersion}');
                }),
              ],
            ),
          );
        },
      ),
      body: BlocBuilder<CombinationItemDbBloc, CombinationItemDbState>(
        builder: (context, state) {
          if (state is CollectionGroupLoadedState) {
            if (state.entities.isEmpty) {
              return const Center(
                child: Text(
                  'No Group Exists. Add your group!',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            }

            List<ItemBaseEntity> groups = state.entities;
            final Size displaySize = MediaQuery.of(context).size;
            final widthMargin = displaySize.width * 0.05;
            final itemHeight = displaySize.height * 0.1;

            return BlocProvider<ReorderItemAnimationBloc>(
              create: (context) => ReorderItemAnimationBloc(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: widthMargin),
                child: CachedReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    context
                        .read<CombinationItemDbBloc>()
                        .add(CombinationGroupReorderEvent(
                          tableName: groupTable,
                          items: groups,
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        ));
                  },
                  list: groups,
                  itemBuilder: (context, item) => Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.8))),
                    key: Key('${item.orderKey}'),
                    height: itemHeight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CombinationPage()));
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.folder_open_outlined),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                          fontSize: displaySize.height * 0.04),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.createdDate.toString(),
                                      style: TextStyle(
                                          fontSize: displaySize.height * 0.02),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 100,
        child: FittedBox(
          child: FloatingActionButton.extended(
              onPressed: () async {
                final groupName = await showGenericDialog(
                  context: context,
                  title: 'Add group',
                  optionBuilder: () => {
                    'Cancel': null,
                    'Create': true,
                  },
                );

                if (!context.mounted) return;

                if (groupName != null) {
                  context
                      .read<CombinationItemDbBloc>()
                      .add(CombinationGroupCreateEvent(groupName: groupName));
                }
              },
              label: const Row(
                children: [
                  Icon(Icons.add),
                  Text('Add Group'),
                ],
              )),
        ),
      ),
    );
  }
}
