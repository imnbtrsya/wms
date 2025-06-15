import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wms/model/managerating/rating_model.dart';
import 'package:wms/screen/managerating/foremen_list.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RatingFormScreen extends StatefulWidget {
  final Foreman foreman;

  const RatingFormScreen({super.key, required this.foreman});

  @override
  State<RatingFormScreen> createState() => _RatingFormScreenState();
}

class _RatingFormScreenState extends State<RatingFormScreen> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    String reviewText = _reviewController.text.trim();

    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating')),
      );
    return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userName = userDoc.data()?['name'] ?? 'Anonymous';
      final userEmail = user.email ?? 'NoEmail';

      print("User ID: ${user.uid}");
      print("User Name from Firestore: $userName");
      print("User Email from FirebaseAuth: ${user.email}");
      print("User Email from Firestore: ${userDoc.data()?['email']}");

      await FirebaseFirestore.instance.collection('ratings').add({
        'foremanId': widget.foreman.id,
        'foremanName': widget.foreman.name,
        'ownerId': user.uid,
        'name': userName,
        'ownerEmail': userEmail,
        'rating': _rating,
        'review': reviewText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _rating = 0.0;
        _reviewController.clear();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RatingFeedbackScreen()),
      );
    } catch (e) {
      print("Error during submission: $e"); // 👈 Add this
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foreman = widget.foreman;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating & Feedback'),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(foreman.image),
              ),
              const SizedBox(height: 16),
              Text(
                foreman.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Star Rating Box
              Container(
                width: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade700),
                ),
                child: Column(
                  children: [
                    Text(
                      "How's your experience with ${foreman.name}'s service?",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 36,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Review Box
              Container(
                width: 400,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add detailed review",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write your review here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> hasRated(String foremanId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('ratings')
      .where('foremanId', isEqualTo: foremanId)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
}

