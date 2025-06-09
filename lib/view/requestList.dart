import 'package:flutter/material.dart';
import '../pages/requestController.dart';
import '../models/inventoryRequest.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  final RequestController _requestController = RequestController();

  @override
  Widget build(BuildContext context) {
    final requests = _requestController.getRequests();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Requests')),
      body: requests.isEmpty
          ? const Center(child: Text('No requests found'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return ListTile(
                  title: Text(req.name),
                  subtitle: Text('Address: ${req.address}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newRequest = await Navigator.pushNamed(context, '/requestInventory') as InventoryRequest?;
          if (newRequest != null) {
            setState(() {
              _requestController.addRequest(newRequest);
            });
          }
        },
      ),
    );
  }
}
