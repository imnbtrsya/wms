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

  factory InventoryRecord.fromMap(Map<String, dynamic> map) {
    return InventoryRecord(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      category: map['category'] ?? '',
      unitPrice: (map['unitPrice'] as num).toDouble(),
      sellingPrice: (map['sellingPrice'] as num).toDouble(),
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'category': category,
      'unitPrice': unitPrice,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
    };
  }
}
