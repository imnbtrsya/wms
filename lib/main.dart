import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wms/screen/auth/login.dart';
import 'package:wms/screen/auth/register.dart';
import 'package:wms/screen/dashboard/foremen_dashboard.dart';
import 'package:wms/screen/dashboard/owner_dashboard.dart'; 
import 'package:wms/screen/managerating/foremen_list.dart';
import 'package:wms/screen/managerating/rated_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD4_nahE0Hes0ypZRmt4Ib0J1iNW57wGfM",
        authDomain: "wms-gpsep.firebaseapp.com",
        projectId: "wms-gpsep",
        storageBucket: "wms-gpsep.appspot.com", 
        messagingSenderId: "467023206497",
        appId: "1:467023206497:web:87c10c54efe4aadcb6b220",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workshop Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(), //login
        '/register': (context) => const RegisterScreen(), //register
        '/foremanDashboard': (context) => const ForemenDashboard(), //foreman dashboard
        '/ownerDashboard': (context) => const OwnerDashboard(), //owner dashboard
        '/foremenList': (context) => const RatingFeedbackScreen(), //foreman list screen
        '/ratedList': (context) => const RatedListScreen(), //rated list screen
      },
    );
  }
}
