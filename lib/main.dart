import 'package:combinators/services/bloc/account/account_bloc.dart';
import 'package:combinators/services/bloc/app_info/app_info_bloc.dart';
import 'package:combinators/services/bloc/crud/combination_item_crud_bloc.dart';
import 'package:combinators/services/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:combinators/services/bloc/home_view/home_view_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_event.dart';
import 'package:combinators/services/bloc/route_controller/route_state.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider(
    create: (context) => DarkModeBloc(),
    child: BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Combinations',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<RouteBloc>(
                create: (context) => RouteBloc(),
              ),
              BlocProvider<AccountBloc>(
                create: (context) => AccountBloc(),
              ),
              BlocProvider<HomeViewBloc>(
                create: (context) => HomeViewBloc(),
              ),
              BlocProvider<AppInfoBloc>(
                create: (context) => AppInfoBloc(),
              ),
            ],
            child: RepositoryProvider(
              create: (context) => CombinationItemRepository(),
              child: BlocProvider(
                create: (context) => CombinationItemDbBloc(
                    context.read<CombinationItemRepository>(),),
                child: const HomePage(),
              ),
            ),
          ),
        );
      },
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RouteBloc>().add(const RouteHomeEvent());
    return BlocConsumer<RouteBloc, RouteState>(
        listener: (BuildContext context, RouteState state) {},
        builder: (context, state) {
          return state.view;
        });
  }
}
