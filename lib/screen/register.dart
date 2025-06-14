import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _contact = '';
  String _password = '';
  String _role = 'Owner';
  String _shopAddress = '';
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    _formKey.currentState!.save();

    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      User? user = result.user;

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'name': _name,
        'email': _email,
        'contact': _contact,
        'role': _role,
        'shopAddress': _role == 'Owner' ? _shopAddress : '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                        onSaved: (val) => _name = val!,
                        validator: (val) => val!.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                        onSaved: (val) => _email = val!,
                        validator: (val) => val!.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
                        onSaved: (val) => _contact = val!,
                        validator: (val) => val!.isEmpty ? 'Enter contact' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        onChanged: (val) => _password = val,
                        validator: (val) => val!.length < 6 ? 'Min 6 characters' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (val) => val != _password ? 'Passwords don\'t match' : null,
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _role,
                        items: ['Owner', 'Foreman'].map((role) {
                          return DropdownMenuItem(value: role, child: Text(role));
                        }).toList(),
                        onChanged: (val) => setState(() => _role = val!),
                        decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),

                      if (_role == 'Owner')
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Shop Address', border: OutlineInputBorder()),
                          onSaved: (val) => _shopAddress = val!,
                          validator: (val) => val!.isEmpty ? 'Enter shop address' : null,
                        ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
