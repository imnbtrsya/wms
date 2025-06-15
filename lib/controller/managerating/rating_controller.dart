import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/managerating/rating_model.dart';
import 'package:wms/services/managerating/rating_service.dart';

class RatingController {
  final RatingService _ratingService = RatingService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieves a list of all foremen using the service layer
  Future<List<Foreman>> getForemen() => _ratingService.getForemen();

  // Checks if a foreman has been rated
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

    // Submit the rating through the service
    await _ratingService.submitRating(ratingData);
  }

  // Retrieves the first rating document for a given foreman
  Future<DocumentSnapshot?> getRatingByForemanId(String foremanId) {
    return _ratingService.getRatingByForemanId(foremanId);
  }

  // Retrieves a rating using Firestore document ID.
  Future<Rating?> getRatingByDocId(String docId) {
    return _ratingService.getRatingByDocId(docId);
  }

  // Updates a specific rating
  Future<void> updateRating(String docId, Rating updatedRating) {
    return _ratingService.updateRating(docId, updatedRating);
  }

  // Deletes a specific rating
  Future<void> deleteRating(String docId) {
    return _ratingService.deleteRating(docId);
  }

  // Retrieves all ratings in the system, sorted by timestamp
  Future<List<Rating>> getAllRatings() {
    return _ratingService.getAllRatings();
  }

  // Retrieves a rating submitted by a specific owner for a specific foreman.
  Future<Rating?> getRatingByOwnerAndForeman(String ownerId, String foremanId) {
    return _ratingService.getRatingByOwnerAndForeman(ownerId, foremanId);
  }

  Future<List<Rating>> getRatingsForCurrentForeman() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('ratings')
        .where('foremanId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Rating.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Rating>> getRatingsByForemanId(String foremanId) {
  return _ratingService.getRatingsByForemanId(foremanId);
}
}
