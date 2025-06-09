class InventoryRecord {
  final String name;
  final String code;
  final String category;
  final double unitPrice;
  final double sellingPrice;
  final int quantity;

  InventoryRecord({
    required this.name,
    required this.code,
    required this.category,
    required this.unitPrice,
    required this.sellingPrice,
    required this.quantity,
  });
}
