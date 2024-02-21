import 'package:combinators/oss_licenses.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSourceLicenseDetailView extends StatelessWidget {
  final int index;

  const OpenSourceLicenseDetailView({super.key, required this.index});

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {}
  }

  @override
  Widget build(BuildContext context) {
    Package license = ossLicenses[index];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            license.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          children: [
            const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text(license.description ?? ''),
            const Divider(),
            const Text('Homepage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Center(
              child: ElevatedButton(
                child: Text(license.homepage ?? ''),
                onPressed: () async =>
                    await _launchUrl(Uri.parse(license.homepage ?? '')),
              ),
            ),
            const Divider(),
            const Text('Repository', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Center(
              child: ElevatedButton(
                child: Text(license.repository ?? ''),
                onPressed: () async =>
                await _launchUrl(Uri.parse(license.repository ?? '')),
              ),
            ),
            const Divider(),
            const Text('Authors', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text(license.authors.join(', ') ?? ''),
            const Divider(),
            const Text('Version', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text(license.version ?? ''),
            const Divider(),
            const Text('License', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text(license.license ?? '')
          ],
        ));
  }
}
