import 'package:cloud_firestore/cloud_firestore.dart';

class Foreman {
  final String id;
  final String name;
  final String image;

  Foreman({
    required this.id,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory Foreman.fromMap(Map<String, dynamic> map) {
    return Foreman(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? 'assets/user.jpg',
    );
  }

  factory Foreman.fromUserDoc(String docId, Map<String, dynamic> map) {
    return Foreman(
      id: docId,
      name: map['name'] ?? '',
      image: map['image'] ?? 'assets/user.jpg',
    );
  }
}

class Rating {
  final String? id;
  final String foremanId;
  final String foremanName;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final double rating;
  final String review;
  final DateTime timestamp;

  Rating({
    this.id,
    required this.foremanId,
    required this.foremanName,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.rating,
    required this.review,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'foremanId': foremanId,
      'foremanName': foremanName,
      'ownerId': ownerId,
      'name': ownerName,
      'ownerEmail': ownerEmail,
      'rating': rating,
      'review': review,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map, [String? id]) {
    print('Rating fromMap: ${map}');
    
    return Rating(
      id: id,
      foremanId: map['foremanId'] ?? '',
      foremanName: map['foremanName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['name'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      review: map['review'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}