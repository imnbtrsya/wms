import 'package:flutter/material.dart';
import 'package:wms/screen/owner_dashboard.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OwnerDashboard()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/'); // only if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rating'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/foremenList');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
