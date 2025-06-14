import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/rating_model.dart';
import 'package:wms/services/rating_service.dart';

class RatingController {
  final RatingService _ratingService = RatingService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Foreman>> getForemen() => _ratingService.getForemen();

  Future<bool> hasRated(String foremanId) => _ratingService.hasRating(foremanId);

  Future<void> submitRating({
    required String foremanId,
    required String foremanName,
    required double rating,
    required String review,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final ownerName = userDoc.data()?['name'] ?? 'Anonymous';
    final ownerEmail = user.email ?? 'NoEmail';

    final ratingData = Rating(
      foremanId: foremanId,
      foremanName: foremanName,
      ownerId: user.uid,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      rating: rating,
      review: review,
      timestamp: DateTime.now(),
    );

    await _ratingService.submitRating(ratingData);
  }
}
