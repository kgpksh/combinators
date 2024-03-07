import 'package:combinators/services/advertisement/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  static int maxLoadTry = 5;
  int loadCount = maxLoadTry;
  static final InterstitialAdService _interstitialAdService =
  InterstitialAdService._sharedInstance();

  InterstitialAdService._sharedInstance();

  factory InterstitialAdService() => _interstitialAdService;

  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );

          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) async {
          _interstitialAd = null;
          await Future.delayed(const Duration(milliseconds: 500));
          if(loadCount > 0) {
            loadInterstitialAd();
            loadCount -= 1;
          }

        },
      ),
    );
  }

  void showInterstitialAd() {
    loadCount = maxLoadTry;
    if(_interstitialAd == null) {
      loadInterstitialAd();
    }
    _interstitialAd?.show();

  }

  void disposeInterstitialAd() {
    _interstitialAd?.dispose();
    loadCount = maxLoadTry;
  }
}