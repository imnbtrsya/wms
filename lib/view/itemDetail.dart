import 'package:flutter/material.dart';
import '../models/inventoryRecord.dart';

class ItemDetailPage extends StatelessWidget {
  final InventoryRecord item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back to InventoryPage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${item.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Code: ${item.code}', style: const TextStyle(fontSize: 16)),
            Text('Category: ${item.category}', style: const TextStyle(fontSize: 16)),
            Text('Unit Price: \$${item.unitPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            Text('Selling Price: \$${item.sellingPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            Text('Quantity: ${item.quantity}', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final editedItem = await Navigator.pushNamed(
                    context,
                    '/editInventory',
                    arguments: item,
                  ) as InventoryRecord?;

                  if (editedItem != null) {
                    Navigator.pop(context, editedItem); // Return to InventoryPage
                  }
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
