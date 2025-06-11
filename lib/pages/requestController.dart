import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventoryRequest.dart';

class RequestController {
  final CollectionReference _requestCollection =
      FirebaseFirestore.instance.collection('inventory_requests');

  // ✅ Add a new request to Firebase
  Future<void> addRequest(InventoryRequest request) async {
    await _requestCollection.add(request.toMap());
  }

  // ✅ Get all requests from Firebase
  Future<List<InventoryRequest>> getRequests() async {
    final querySnapshot = await _requestCollection.get();
    return querySnapshot.docs
        .map((doc) => InventoryRequest.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
