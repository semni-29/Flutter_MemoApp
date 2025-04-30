// tabsPage.dart
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TabsPage extends StatelessWidget {
  final FirebaseAnalytics analytics;

  const TabsPage(this.analytics, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 원하는 곳에서 analytics 사용 가능
    return Scaffold(
      appBar: AppBar(title: const Text("Tabs Page")),
      body: Center(child: Text("Tabs Content")),
    );
  }
}
