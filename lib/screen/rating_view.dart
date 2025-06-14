import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/model/rating_model.dart';
import 'package:wms/screen/rating_edit.dart';

class RatingViewScreen extends StatefulWidget {
  final Foreman foreman;

  const RatingViewScreen({super.key, required this.foreman});

  @override
  State<RatingViewScreen> createState() => _RatingViewScreenState();
}

class _RatingViewScreenState extends State<RatingViewScreen> {
  late Future<DocumentSnapshot> _ratingFuture;

  @override
  void initState() {
    super.initState();
    _ratingFuture = FirebaseFirestore.instance
        .collection('ratings')
        .where('foremanId', isEqualTo: widget.foreman.id)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);
  }

  Widget buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating Detail"),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _ratingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No rating found."));
          }

          final docId = snapshot.data!.id;
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final double rating = data['rating']?.toDouble() ?? 0.0;
          final String review = data['review'] ?? 'No review provided';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildRatingStars(rating),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const Text(
                          "Review:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          review,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RatingEditScreen(
                              docId: docId,
                              foreman: widget.foreman,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Rating"),
                            content: const Text("Are you sure you want to delete this rating?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await FirebaseFirestore.instance
                              .collection('ratings')
                              .doc(docId)
                              .delete();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rating deleted successfully'),
                              backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.pop(context, 'deleted');
                          }
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
