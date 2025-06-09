import 'package:flutter/material.dart';
import '../models/inventoryRequest.dart';

class RequestInventoryPage extends StatefulWidget {
  const RequestInventoryPage({super.key});

  @override
  State<RequestInventoryPage> createState() => _RequestInventoryPageState();
}

class _RequestInventoryPageState extends State<RequestInventoryPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  String? _selectedAddress;

  final List<String> _addresses = ['Beserah', 'Air Putih', 'Indera Mahkota'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedAddress != null) {
      final newRequest = InventoryRequest(
        name: _nameController.text,
        address: _selectedAddress!,
      );
      Navigator.pop(context, newRequest);
    } else if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Address'),
                value: _selectedAddress,
                items: _addresses.map((address) {
                  return DropdownMenuItem(
                    value: address,
                    child: Text(address),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                },
                validator: (value) => value == null ? 'Please select an address' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
