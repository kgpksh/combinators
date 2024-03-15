import 'package:combinators/views/home/drawers/open_source_license_list_view.dart';
import 'package:combinators/views/utils/launch_url.dart';
import 'package:flutter/material.dart';

class AboutThisAppPage extends StatelessWidget {
  const AboutThisAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About this App'),
      ),
      body: Column(
        children: [
          ListTile(
              title: const Text('Open Source Licenses'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OssLicensesListPage()));
              }),
          ListTile(
            title: const Text('Terms & Conditions'),
            onTap: () async {
              await openBrowserLink(Uri.parse(
                  'https://sites.google.com/view/combinators-terms-condition/%ED%99%88'));
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () async {
              await openBrowserLink(Uri.parse(
                  'https://sites.google.com/view/codecrafter-combinator-privacy/%ED%99%88'));
            },
          )
        ],
      ),
    );
  }
}
