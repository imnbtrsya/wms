import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/controller/rating_controller.dart';
import 'package:wms/model/rating_model.dart';
import 'package:wms/screen/rating_form.dart';
import 'package:wms/widgets/owner_sidebar.dart';
import 'package:wms/screen/rating_view.dart';
import 'package:wms/screen/owner_dashboard.dart';

class RatingFeedbackScreen extends StatefulWidget {
  const RatingFeedbackScreen({super.key});

  @override
  State<RatingFeedbackScreen> createState() => _RatingFeedbackScreenState();
}

class _RatingFeedbackScreenState extends State<RatingFeedbackScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Foreman>> _foremenFuture;
  List<Foreman> _allForemen = [];
  List<Foreman> _filteredForemen = [];

  @override
  void initState() {
    super.initState();
    _foremenFuture = RatingController().getForemen();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredForemen = _allForemen
          .where((foreman) => foreman.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> hasRated(String foremanId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('foremanId', isEqualTo: foremanId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating & Feedback"),
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
            tooltip: 'Owner Dashboard',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OwnerDashboard()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search foremen...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Foreman>>(
              future: _foremenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No foremen found'));
                } else {
                  _allForemen = snapshot.data!;
                  _filteredForemen = _searchController.text.isEmpty
                      ? _allForemen
                      : _allForemen
                          .where((foreman) => foreman.name
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .toList();

                  if (_filteredForemen.isEmpty) {
                    return const Center(
                      child: Text(
                        'No foreman found',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _filteredForemen.length,
                    itemBuilder: (context, index) {
                      final foreman = _filteredForemen[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(foreman.image),
                          radius: 28,
                        ),
                        title: Text(foreman.name),
                        subtitle: Row(
                          children: [
                            Text("Jobs Completed: ${foreman.jobs}   "),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                Text("${foreman.rating}"),
                              ],
                            ),
                          ],
                        ),
                        trailing: FutureBuilder<bool>(
                          future: hasRated(foreman.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(
                                width: 80,
                                height: 36,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            final isRated = snapshot.data!;

                            return ElevatedButton(
                              onPressed: () async {
                                if (isRated) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RatingViewScreen(foreman: foreman),
                                    ),
                                  );

                                  if (result == 'deleted') {
                                    setState(() {}); // Rebuild to show RATE button
                                  }
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RatingFormScreen(foreman: foreman),
                                    ),
                                  );
                                  setState(() {}); // Rebuild to show VIEW button
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isRated
                                    ? Colors.white
                                    : Colors.blue.shade700,
                                foregroundColor: isRated
                                    ? Colors.blue.shade700
                                    : Colors.white,
                              ),
                              child: Text(isRated ? "VIEW" : "RATE"),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
