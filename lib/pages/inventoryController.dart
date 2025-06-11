import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventoryRecord.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<InventoryRecord> _items = [];

  List<InventoryRecord> getItems() => _items;

  /// ✅ Fetch all items from Firestore
  Future<void> fetchItems() async {
    final snapshot = await _firestore.collection('inventory').get();
    _items.clear();
    for (var doc in snapshot.docs) {
      _items.add(InventoryRecord.fromMap(doc.data()));
    }
  }

  /// ✅ Add a new item to Firestore and local list
  Future<void> addItem(InventoryRecord newItem) async {
    await _firestore.collection('inventory').doc(newItem.code).set(newItem.toMap());
    _items.add(newItem);
  }

  /// ✅ Update an existing item
  Future<void> updateItem(InventoryRecord updatedItem) async {
    final index = _items.indexWhere((item) => item.code == updatedItem.code);
    if (index != -1) {
      await _firestore.collection('inventory').doc(updatedItem.code).update(updatedItem.toMap());
      _items[index] = updatedItem;
    }
  }
}
