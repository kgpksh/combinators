import 'package:combinators/services/bloc/account/account_bloc.dart';
import 'package:combinators/services/bloc/app_info/app_info_bloc.dart';
import 'package:combinators/services/bloc/crud/combination/combination_bloc.dart';
import 'package:combinators/services/bloc/crud/group/combination_group_bloc.dart';
import 'package:combinators/services/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_bloc.dart';
import 'package:combinators/services/bloc/route_controller/route_event.dart';
import 'package:combinators/services/bloc/route_controller/route_state.dart';
import 'package:combinators/services/crud/combination_item_service.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'services/advertisement/interstitial_ad.dart';
import 'services/advertisement/rewarded_ad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(BlocProvider(
    create: (context) => DarkModeBloc(),
    child: BlocBuilder<DarkModeBloc, bool>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Combinations',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: state ? ThemeMode.dark : ThemeMode.light,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<RouteBloc>(
                create: (context) => RouteBloc(),
              ),
              BlocProvider<AccountBloc>(
                create: (context) => AccountBloc(),
              ),
              BlocProvider<AppInfoBloc>(
                create: (context) => AppInfoBloc(),
              ),
            ],
            child: RepositoryProvider(
              create: (context) => CombinationItemRepository(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CombinationGroupDbBloc(
                      context.read<CombinationItemRepository>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => CombinationBloc(
                      context.read<CombinationItemRepository>(),
                    ),
                  ),
                ],
                child: const HomePage(),
              ),
            ),
          ),
        );
      },
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(InitAccountEvent());
    context.read<RouteBloc>().add(const RouteHomeEvent());
  }

  @override
  void dispose() {
    super.dispose();
    InterstitialAdService().disposeInterstitialAd();
    RewardedAdService().disposeRewardedAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size size = MediaQuery.of(context).size;
    DisplaySize.instance.setDisplayHeight(size);
    DisplaySize.instance.setDisplayWidth(size);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
      if (state is! AccountSubscribed) {
        InterstitialAdService().loadInterstitialAd();
        RewardedAdService().loadRewardedAd();
      } else {
        InterstitialAdService().disposeInterstitialAd();
        RewardedAdService().disposeRewardedAd();
      }
    }, builder: (context, state) {
      if (state is! AccountSubscribed) {
        InterstitialAdService().loadInterstitialAd();
        RewardedAdService().loadRewardedAd();
      } else {
        InterstitialAdService().disposeInterstitialAd();
        RewardedAdService().disposeRewardedAd();
      }
      return BlocBuilder<RouteBloc, RouteState>(builder: (context, state) {
        return state.view;
      });
    });
  }
}
