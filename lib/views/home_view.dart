import 'package:combinators/services/bloc/app_info/app_info_bloc.dart';
import 'package:combinators/services/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_event.dart';
import 'package:combinators/views/drawers/open_source_license_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/bloc/account/account_bloc.dart';
import '../services/bloc/home_view/home_view_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AppInfoBloc>().add(CallAppInfoEvent());
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OssLicensesListPage()));
                      // context
                      //     .read<RouteBloc>()
                      //     .add(const RouteOpenSourceLicenseListEvent());
                    }),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text('Dark Mode'),
                      BlocBuilder<DarkModeBloc, DarkModeState>(
                        builder: (context, state) {
                          return Switch(
                              value: state.isDarkMode,
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
      body: BlocBuilder<HomeViewBloc, HomeViewState>(
        builder: (context, state) {
          return ListView(
            children: [
              const ListTile(
                title: Text('a'),
              )
            ],
          );
        },
      ),
    );
  }

  void setState(Null Function() param0) {}
}
