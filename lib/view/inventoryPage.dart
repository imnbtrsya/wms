import 'package:flutter/material.dart';
import '../pages/inventoryController.dart';
import '../models/inventoryRecord.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final InventoryController _controller = InventoryController();

  @override
  Widget build(BuildContext context) {
    final items = _controller.getItems();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Code: ${item.code} | Category: ${item.category}'),
              trailing: Text('Qty: ${item.quantity}'),
              onTap: () async {
                final updatedItem = await Navigator.pushNamed(context, '/itemDetail', arguments: item) as InventoryRecord?;
                if (updatedItem != null) {
                  setState(() {
                    _controller.updateItem(updatedItem);
                  });
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () async {
                final newItem = await Navigator.pushNamed(context, '/addInventory') as InventoryRecord?;
                if (newItem != null) {
                  setState(() {
                    _controller.addItem(newItem);
                  });
                }
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.request_page),
              label: const Text('Request'),
              onPressed: () {
                Navigator.pushNamed(context, '/requestList');
              },
            ),
          ],
        ),
      ),
    );
  }
}
