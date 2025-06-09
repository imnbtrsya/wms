import '../models/inventoryRecord.dart';

class InventoryController {
  final List<InventoryRecord> _items = [
    InventoryRecord(
      name: "Laptop",
      code: "ITM001",
      category: "Electronics",
      unitPrice: 1000.0,
      sellingPrice: 1200.0,
      quantity: 10,
    ),
    InventoryRecord(
      name: "Mouse",
      code: "ITM002",
      category: "Accessories",
      unitPrice: 15.0,
      sellingPrice: 25.5,
      quantity: 50,
    ),
    InventoryRecord(
      name: "Keyboard",
      code: "ITM003",
      category: "Accessories",
      unitPrice: 30.0,
      sellingPrice: 45.0,
      quantity: 30,
    ),
  ];

  List<InventoryRecord> getItems() => _items;

  void addItem(InventoryRecord newItem) {
    _items.add(newItem);
  }

  void updateItem(InventoryRecord updatedItem) {
    final index = _items.indexWhere((item) => item.code == updatedItem.code);
    if (index != -1) {
      _items[index] = updatedItem;
    }
  }
}
