import 'package:flutter/material.dart';
import 'view/inventoryPage.dart';
import 'view/itemDetail.dart';
import 'view/editInventory.dart';
import 'view/addInventory.dart';
import 'view/requestList.dart';
import 'view/requestInventory.dart';
import 'models/inventoryRecord.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      initialRoute: '/',
      routes: {
        '/': (context) => const InventoryPage(),
        '/addInventory': (context) => const AddInventoryPage(),
        '/requestList': (context) => const RequestListPage(),
        '/requestInventory': (context) => const RequestInventoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/itemDetail') {
          final item = settings.arguments as InventoryRecord;
          return MaterialPageRoute(
            builder: (context) => ItemDetailPage(item: item),
          );
        } else if (settings.name == '/editInventory') {
          final item = settings.arguments as InventoryRecord;
          return MaterialPageRoute(
            builder: (context) => EditInventoryPage(item: item),
          );
        }
        return null;
      },
    );
  }
}
