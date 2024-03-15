import 'package:combinators/oss_licenses.dart';
import 'package:combinators/views/utils/display_size.dart';
import 'package:combinators/views/utils/launch_url.dart';
import 'package:flutter/material.dart';

class OpenSourceLicenseDetailView extends StatelessWidget {
  final int index;

  const OpenSourceLicenseDetailView({super.key, required this.index});

  Widget checkEmptyData({required data}) {
    if(data == null) {
      return SizedBox(
        width: double.infinity,
        height: DisplaySize.instance.displayHeight * 0.05,
        child: const Text('No Link'),
      );
    }

    return Center(
      child: ElevatedButton(
        child: Text(data),
        onPressed: () async =>
        await openBrowserLink(Uri.parse(data)),
      ),
    );
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
            checkEmptyData(data: license.homepage),
            const Divider(),
            const Text('Repository', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            checkEmptyData(data: license.repository),
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
