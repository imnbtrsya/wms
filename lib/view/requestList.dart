import 'package:flutter/material.dart';
import '../pages/requestController.dart';
import '../models/inventoryRequest.dart';
import 'sidebar.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  final RequestController _requestController = RequestController();
  late Future<List<InventoryRequest>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _requestsFuture = _requestController.getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Requests')),
      drawer: const AppSidebar(), // Use shared sidebar
      body: FutureBuilder<List<InventoryRequest>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading requests'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found'));
          }

          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return ListTile(
                title: Text(req.name),
                subtitle: Text('Address: ${req.address}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newRequest = await Navigator.pushNamed(
            context,
            '/requestInventory',
          ) as InventoryRequest?;

          if (newRequest != null) {
            await _requestController.addRequest(newRequest);
            setState(() {
              _loadRequests(); // Reload data after adding
            });
          }
        },
      ),
    );
  }
}
