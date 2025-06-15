import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/managerating/rating_model.dart';

class RatingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetches a list of all foremen from the 'users'
  Future<List<Foreman>> getForemen() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Foreman')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return Foreman.fromUserDoc(doc.id, data);
  }).toList();
}

  // Submits a new rating to the 'ratings'
  Future<void> submitRating(Rating rating) async {
  final existing = await getRatingByOwnerAndForeman(rating.ownerId, rating.foremanId);
  if (existing != null) {
    // Optional: update instead
    await updateRating(existing.id!, rating);
  } else {
    await _db.collection('ratings').add(rating.toMap());
  }
}

  // Checks if a rating exists for a specific foreman.
  Future<bool> hasRating(String foremanId) async {
    final snapshot = await _db
        .collection('ratings')
        .where('foremanId', isEqualTo: foremanId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Retrieves the first rating document for a specific foreman by their ID.
  Future<DocumentSnapshot?> getRatingByForemanId(String foremanId) async {
    final snapshot = await _db
        .collection('ratings')
        .where('foremanId', isEqualTo: foremanId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
  }

 // Retrieves a specific rating using its document ID & returns a Rating object if found
  Future<Rating?> getRatingByDocId(String docId) async {
    final doc = await _db.collection('ratings').doc(docId).get();
    if (!doc.exists) return null;
    return Rating.fromMap(doc.data()!, doc.id);
  }

  // Updates an existing rating using its document ID
  Future<void> updateRating(String docId, Rating updatedRating) async {
    await _db.collection('ratings').doc(docId).update(updatedRating.toMap());
  }

  //Deletes a rating by its document ID
  Future<void> deleteRating(String docId) async {
    await _db.collection('ratings').doc(docId).delete();
  }

  //Retrieves all ratings from the 'ratings' by timestamp
  Future<List<Rating>> getAllRatings() async {
    final snapshot = await _db.collection('ratings').orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map((doc) => Rating.fromMap(doc.data(), doc.id))
        .toList();
  }

  //Retrieves a rating submitted by a specific owner for a specific foreman
  Future<Rating?> getRatingByOwnerAndForeman(String ownerId, String foremanId) async {
    final snapshot = await _db
        .collection('ratings')
        .where('ownerId', isEqualTo: ownerId)
        .where('foremanId', isEqualTo: foremanId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return Rating.fromMap(doc.data(), doc.id);
  }

  Future<List<Rating>> getRatingsByForemanId(String foremanId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('foremanId', isEqualTo: foremanId)
        .get();

    return querySnapshot.docs
        .map((doc) => Rating.fromMap(doc.data()))
        .toList();
  }

  // Checks if the owner has rated this specific foreman
  Future<bool> hasRatedForeman(String ownerId, String foremanId) async {
    final snapshot = await _db
      .collection('ratings')
      .where('ownerId', isEqualTo: ownerId)
      .where('foremanId', isEqualTo: foremanId)
      .limit(1)
      .get();

    return snapshot.docs.isNotEmpty;
  }
}