import 'package:url_launcher/url_launcher.dart';

Future<void> openBrowserLink(Uri url) async {
  await launchUrl(url, mode: LaunchMode.externalApplication);
}