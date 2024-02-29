import 'package:combinators/services/bloc/app_info/app_info_bloc.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/bloc/crud/group/combination_group_bloc.dart';
import 'package:combinators/services/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:combinators/services/crud/entity/group_entity.dart';
import 'package:combinators/views/combine/combinator.dart';
import 'package:combinators/views/utils/cached_reorderable_list_view.dart';
import 'package:combinators/views/home/drawers/open_source_license_list_view.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:combinators/views/utils/loading_view.dart';
import 'package:combinators/views/utils/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/bloc/account/account_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double displayHeight = DisplaySize.instance.displayHeight;
    double displayWidth = DisplaySize.instance.displayWidth;
    context.read<AppInfoBloc>().add(CallAppInfoEvent());
    context.read<CombinationGroupDbBloc>().add(CombinationGroupLoadEvent());

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
      body: BlocBuilder<CombinationGroupDbBloc, CombinationGroupDbState>(
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

            List<DatabaseGroup> groups = state.entities;
            final widthMargin = displayWidth * 0.05;
            final itemHeight = displayHeight * 0.1;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widthMargin),
              child: CachedReorderableListView(
                scrollDirection: Axis.vertical,
                onReorder: (int oldIndex, int newIndex) {
                  context
                      .read<CombinationGroupDbBloc>()
                      .add(CombinationGroupReorderEvent(
                        items: groups,
                        oldIndex: oldIndex,
                        newIndex: newIndex,
                      ));
                },
                list: groups,
                itemBuilder: (context, item) => SizedBox(
                  key: Key('${item.orderKey}'),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.8))),
                    height: itemHeight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 200), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<CombinationGroupDbBloc>.value(
                                        value: BlocProvider.of<CombinationGroupDbBloc>(context),
                                      ),
                                      BlocProvider<CombinationBloc>.value(
                                        value: BlocProvider.of<CombinationBloc>(context),
                                      ),
                                    ],
                                    child: CombinationPage(
                                      groupName: item.name,
                                      groupId: item.id,
                                    ),
                                  ),
                                ),
                              );
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
                                          fontSize: displayHeight * 0.04),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.createdDate.toString(),
                                      style: TextStyle(
                                          fontSize: displayHeight * 0.02),
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

          return const LoadingView();
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
                  defaultText: '',
                  hintText: 'Enter Group Name',
                  optionBuilder: () => {
                    'Cancel': null,
                    'Create': true,
                  },
                );

                if (!context.mounted) return;

                if (groupName != null && groupName != '') {
                  context
                      .read<CombinationGroupDbBloc>()
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
