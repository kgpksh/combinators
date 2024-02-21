import 'package:combinators/oss_licenses.dart';
import 'package:combinators/views/drawers/open_source_license_detail_view.dart';
import 'package:flutter/material.dart';

class OssLicensesListPage extends StatelessWidget {
  const OssLicensesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Source Licenses'),
      ),
      body: ListView.separated(
        itemCount: ossLicenses.length,
        itemBuilder: (context, idx) {
          return ListTile(
            title: Text(
              ossLicenses[idx].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenSourceLicenseDetailView(
                    index: idx,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, idx) {
          return const Divider();
        },
      ),
    );
  }
}
