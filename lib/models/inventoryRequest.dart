class InventoryRequest {
  final String name;
  final String address;

  InventoryRequest({
    required this.name,
    required this.address,
  });

  // ✅ Convert InventoryRequest to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }

  // ✅ Optional: Create InventoryRequest from Map
  factory InventoryRequest.fromMap(Map<String, dynamic> map) {
    return InventoryRequest(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
