import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';
import 'package:wms/screen/foremen_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppDrawer(),
      routes: {
        '/foremenList': (context) => const RatingFeedbackScreen(),
      },
    );
  }
}
