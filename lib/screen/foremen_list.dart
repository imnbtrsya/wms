import 'package:flutter/material.dart';
import 'package:wms/controller/rating_controller.dart';
import 'package:wms/model/rating_model.dart';
import 'package:wms/widgets/sidebar.dart';

class RatingFeedbackScreen extends StatefulWidget {
  const RatingFeedbackScreen({super.key});

  @override
  State<RatingFeedbackScreen> createState() => _RatingFeedbackScreenState();
}

class _RatingFeedbackScreenState extends State<RatingFeedbackScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Foreman> _allForemen;
  late List<Foreman> _filteredForemen;

  @override
  void initState() {
    super.initState();
    _allForemen = RatingController().getForemen();
    _filteredForemen = _allForemen;
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
            child: _filteredForemen.isEmpty
                ? const Center(
                    child: Text(
                      'No foreman found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
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
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: foreman.viewed
                                ? Colors.white
                                : Colors.blue.shade700,
                            foregroundColor: foreman.viewed
                                ? Colors.blue.shade700
                                : Colors.white,
                          ),
                          child: Text(foreman.viewed ? "VIEW" : "RATE"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
