import 'package:flutter/material.dart';
import 'package:wms/model/managerating/rating_model.dart';
import 'package:wms/controller/managerating/rating_controller.dart';
import 'package:wms/screen/managerating/foremen_list.dart';

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
  final RatingController _ratingController = RatingController();

  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRatingData();
  }

  Rating? _originalRating;

  Future<void> _loadRatingData() async {
    final rating = await _ratingController.getRatingByDocId(widget.docId);
    if (rating != null) {
      setState(() {
        _originalRating = rating; 
        _rating = rating.rating;
        _reviewController.text = rating.review;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRating() async {
    if (_originalRating == null) return;

    final updatedRating = Rating(
      foremanId: widget.foreman.id,
      foremanName: widget.foreman.name,
      ownerId: _originalRating!.ownerId,
      ownerName: _originalRating!.ownerName,
      ownerEmail: _originalRating!.ownerEmail,
      rating: _rating,
      review: _reviewController.text.trim(),
      timestamp: DateTime.now(),
    );

    await _ratingController.updateRating(widget.docId, updatedRating);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating successfully updated!'),
          backgroundColor: Colors.green,
      ) ,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RatingFeedbackScreen()),
        (route) => false,
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