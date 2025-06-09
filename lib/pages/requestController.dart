import '../models/inventoryRequest.dart';

class RequestController {
  final List<InventoryRequest> _requests = [];

  List<InventoryRequest> getRequests() => _requests;

  void addRequest(InventoryRequest request) {
    _requests.add(request);
  }
}
