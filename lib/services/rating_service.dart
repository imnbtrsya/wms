import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/rating_model.dart';

class RatingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Foreman>> getForemen() async {
    final snapshot = await _db.collection('foremen').get();
    return snapshot.docs.map((doc) =>
        Foreman.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  Future<void> submitRating(Rating rating) async {
    await _db.collection('ratings').add(rating.toMap());
  }

  Future<bool> hasRating(String foremanId) async {
    final snapshot = await _db
        .collection('ratings')
        .where('foremanId', isEqualTo: foremanId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
