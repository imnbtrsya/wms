import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/screen/dashboard/foremen_dashboard.dart';
import 'package:wms/screen/dashboard/owner_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool loading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = result.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final role = userData['role'] ?? '';

          if (role == 'Foreman') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ForemenDashboard()),
            );
          } else if (role == 'Owner') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OwnerDashboard()),
            );
          }
        } else {
          throw Exception('User document not found.');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Login failed: $e');
      debugPrint('🔍 Stacktrace:\n$stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Login failed: $e')),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const Text(
                  'Workshop Management System',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, size: 60, color: Colors.blue),
                          const SizedBox(height: 16),
                          Text(
                            'Login to Your Account',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),

                          // Email Field
                          TextFormField(
                            decoration: _boxInputDecoration('Email'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (v) => email = v,
                            validator: (v) => v == null || v.isEmpty ? 'Enter your email' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            decoration: _boxInputDecoration('Password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            onChanged: (v) => password = v,
                            validator: (v) => v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),

                          const SizedBox(height: 12),

                          // Register Link
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text("Don't have an account? Register"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _boxInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
