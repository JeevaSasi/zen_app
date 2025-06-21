import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/shimmer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CentersPage extends StatefulWidget {
  const CentersPage({super.key});

  @override
  State<CentersPage> createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage> {
  final _apiService = ApiService();
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _centers = [];

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  Future<void> _loadCenters() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _apiService.getCentres();
      
      if (response['success'] == true) {
        setState(() {
          _centers = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Failed to load centers';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Centers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCenters,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget.rectangular(height: 150),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget.rectangular(height: 24),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.6),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.3),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.5),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        const ShimmerWidget.rectangular(height: 16, width: 100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShimmerWidget.rectangular(height: 36, width: MediaQuery.of(context).size.width * 0.25),
                        const SizedBox(width: 8),
                        ShimmerWidget.rectangular(height: 36, width: MediaQuery.of(context).size.width * 0.2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCenters,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_centers.isEmpty) {
      return const Center(
        child: Text('No centers available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCenters,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _centers.length,
        itemBuilder: (context, index) {
          final center = _centers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.secondary,
                    Colors.red[100]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      center['image'] as String? ?? 'https://zenkarateschoolofindia.com/images/logo.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.location_city, size: 50),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center['name'] as String? ?? 'Unnamed Center',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                center['address'] as String? ?? 'Address not specified',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              center['contact_number'] as String? ?? 'Phone not specified',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                center['timing'] as String? ?? 'Class schedule not specified',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${center['instructor_count'] ?? 0} Instructors',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // OutlinedButton.icon(
                            //   onPressed: () {
                            //     // Navigate to map
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(content: Text('Map view coming soon')),
                            //     );
                            //   },
                            //   icon: const Icon(Icons.map),
                            //   label: const Text('VIEW MAP'),
                            // ),
                            // const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () {
                                // Call center
                                final phone = center['contact_number'].toString().trim();
                                if (phone != null && phone.isNotEmpty) {
                                  launchUrl(Uri.parse('tel:$phone'));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Phone number not available')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.call),
                              label: const Text('CALL'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
