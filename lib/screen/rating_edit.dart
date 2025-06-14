import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/rating_model.dart';
import 'package:wms/screen/foremen_list.dart';

class RatingEditScreen extends StatefulWidget {
  final String docId;
  final Foreman foreman;

  const RatingEditScreen({
    super.key,
    required this.docId,
    required this.foreman,
  });

  @override
  State<RatingEditScreen> createState() => _RatingEditScreenState();
}

class _RatingEditScreenState extends State<RatingEditScreen> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRatingData();
  }

  Future<void> _loadRatingData() async {
    final doc = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(widget.docId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _rating = (data['rating'] ?? 0).toDouble();
        _reviewController.text = data['review'] ?? '';
        _isLoading = false;
      });
    }
  }

  void _submitRating() async {
    await FirebaseFirestore.instance
        .collection('ratings')
        .doc(widget.docId)
        .update({
      'rating': _rating,
      'review': _reviewController.text.trim(),
      'timestamp': Timestamp.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating successfully updated!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RatingFeedbackScreen()),
        (Route<dynamic> route) => false,
    );
    }
  }

  Widget buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Rating'),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(widget.foreman.image),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.foreman.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "How was your experience with the foreman's services?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  buildRatingStars(),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Optional Comment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                    child: const Text(
                      'Update Rating',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
