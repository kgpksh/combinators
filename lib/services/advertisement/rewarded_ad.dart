import 'package:combinators/services/advertisement/ad_helper.dart';
import 'package:combinators/services/bloc/time_management/time_management_cubit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static int maxLoadTry = 5;
  int loadCount = maxLoadTry;
  TimeManagementCubit timeManagementCubit = TimeManagementCubit();
  static final RewardedAdService _rewardedAdService =
  RewardedAdService._sharedInstance();

  RewardedAdService._sharedInstance();

  factory RewardedAdService() => _rewardedAdService;

  RewardedAd? _rewardedAd;

  void loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );

          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) async {
          _rewardedAd = null;
          await Future.delayed(const Duration(milliseconds: 500));
          if(loadCount > 0) {
            loadRewardedAd();
            loadCount -= 1;
          }
        },
      ),
    );
  }

  void showRewardedAd() {
    loadCount = maxLoadTry;
    if(_rewardedAd == null) {
      loadRewardedAd();
    }
    _rewardedAd?.show(onUserEarnedReward: (_, RewardItem reward) {  });
  }

  void disposeRewardedAd() {
    loadCount = maxLoadTry;
    _rewardedAd?.dispose();
  }
}