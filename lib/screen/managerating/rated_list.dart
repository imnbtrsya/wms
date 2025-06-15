import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wms/controller/managerating/rating_controller.dart';
import 'package:wms/model/managerating/rating_model.dart';
import 'package:wms/screen/dashboard/foremen_dashboard.dart';
import 'package:wms/widgets/foremen_sidebar.dart';
import 'package:wms/screen/managerating/detailed_rated.dart';

class RatedListScreen extends StatefulWidget {
  const RatedListScreen({super.key});

  @override
  State<RatedListScreen> createState() => _RatedListScreenState();
}

class _RatedListScreenState extends State<RatedListScreen> {
  final RatingController _ratingController = RatingController();

  double averageRating = 0.0;
  List<Rating> ratings = [];

  @override
  void initState() {
    super.initState();
    fetchAllRatings();
  }

  Future<void> fetchAllRatings() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final List<Rating> allRatings = await _ratingController.getRatingsByForemanId(currentUser.uid);

    if (allRatings.isEmpty) return;

    double total = 0.0;
    for (var r in allRatings) {
      total += r.rating;
    }

    setState(() {
      ratings = allRatings;
      averageRating = total / allRatings.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ForemenDrawer(),
      appBar: AppBar(
        title: const Text('Rated List'),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Foreman Dashboard',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ForemenDashboard()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ratings.isEmpty
            ? const Center(child: Text("No ratings available."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Average Rating",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < averageRating.round() ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            );
                          }),
                        ),
                        Text(
                          "${averageRating.toStringAsFixed(1)} / 5.0",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        final review = ratings[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailedRatedScreen(
                                  name: review.ownerName,
                                  rating: review.rating,
                                  comment: review.review,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${review.ownerName}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < review.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review.review,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}