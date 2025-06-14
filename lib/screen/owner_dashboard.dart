import 'package:flutter/material.dart';
import 'package:wms/widgets/owner_sidebar.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Workshop Owner!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: Icons.schedule,
                    label: 'Schedule',
                    onTap: () {
                      // Navigate to schedule
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.inventory,
                    label: 'Inventory',
                    onTap: () {
                      // Navigate to inventory
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.star_rate,
                    label: 'Rating',
                    onTap: () {
                     Navigator.pushNamed(context, '/foremenList'); //Navigate to Rating
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.payment,
                    label: 'Payment',
                    onTap: () {
                      // Navigate to payment
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
