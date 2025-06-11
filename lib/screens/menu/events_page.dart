import 'package:flutter/material.dart';
import 'package:zen_app/screens/menu/gallery_page.dart';
import '../../services/api_service.dart';
import '../../widgets/shimmer_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _apiService = ApiService();
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _events = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _apiService.getEvents();
      
      if (response['success'] == true) {
        final events = List<Map<String, dynamic>>.from(response['data']);
        setState(() {
          _events = events;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Failed to load events';
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

  List<Map<String, dynamic>> get _upcomingEvents {
    final now = DateTime.now();
    // return _events.where((event) {
    //   final eventDate = DateTime.parse(event['date'] as String? ?? '');
    //   return eventDate.isAfter(now);
    // }).toList();
    return _events;
  }

  List<Map<String, dynamic>> get _pastEvents {
    final now = DateTime.now();
    // return _events.where((event) {
    //   final eventDate = DateTime.parse(event['date'] as String? ?? '');
    //   return eventDate.isBefore(now);
    // }).toList();
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
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
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget.rectangular(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget.rectangular(height: 24),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.3),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.3),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 4),
                    const ShimmerWidget.rectangular(height: 16),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShimmerWidget.rectangular(height: 36, width: MediaQuery.of(context).size.width * 0.2),
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
              onPressed: _loadEvents,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_events.isEmpty) {
      return const Center(
        child: Text('No events available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(_upcomingEvents, isUpcoming: true),
          _buildEventsList(_pastEvents, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events, {required bool isUpcoming}) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          isUpcoming ? 'No upcoming events' : 'No past events',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  event['image'] as String? ?? 'https://zenkarateschoolofindia.com/images/logo.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.event, size: 50),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event['title'] as String? ?? 'Untitled Event',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isUpcoming && event.containsKey('results'))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event['results'] as String? ?? '',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          event['date'] as String? ?? 'Date not specified',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event['location'] as String? ?? 'Location not specified',
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['description'] as String? ?? 'No description available',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    if (isUpcoming)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Event details coming soon')),
                              );
                            },
                            child: const Text('Details'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registration coming soon')),
                              );
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GalleryPage()),
                          );
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('View Photos'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 