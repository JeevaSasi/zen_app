import 'package:flutter/material.dart';
import 'package:zen_app/screens/menu/gallery_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'National Karate Championship',
      'date': '10-15 June 2023',
      'location': 'Chennai Indoor Stadium',
      'image': 'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg',
      'description': 'Annual national level karate championship with participants from all over India.',
    },
    {
      'title': 'Summer Training Camp',
      'date': '1-10 May 2023',
      'location': 'Zen Karate School HQ',
      'image': 'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg',
      'description': 'Intensive summer training camp for all belt levels. Special guest instructors from Japan.',
    },
    {
      'title': 'Belt Exam',
      'date': '25 April 2023',
      'location': 'Zen Karate School HQ',
      'image': 'https://karate.news/wp-content/uploads/2023/05/image-36.jpeg',
      'description': 'Quarterly belt exam for all students. Registration required.',
    },
  ];
  
  final List<Map<String, dynamic>> _pastEvents = [
    {
      'title': 'District Tournament',
      'date': '15 March 2023',
      'location': 'City Sports Complex',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHgWS4Cgbdo2uqVlSRgiS1vtgaZT-gAbNhhA&s',
      'description': 'District level tournament where our school won 5 gold, 7 silver, and 3 bronze medals.',
      'results': '12 Medals'
    },
    {
      'title': 'International Workshop',
      'date': '5-7 February 2023',
      'location': 'Zen Karate School HQ',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHgWS4Cgbdo2uqVlSRgiS1vtgaZT-gAbNhhA&s',
      'description': 'Three-day workshop conducted by Sensei Yamamoto from Japan.',
      'results': '45 Participants'
    },
    {
      'title': 'New Year Celebration',
      'date': '1 January 2023',
      'location': 'Zen Karate School HQ',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHgWS4Cgbdo2uqVlSRgiS1vtgaZT-gAbNhhA&s',
      'description': 'Annual new year celebration with demonstrations and awards ceremony.',
      'results': 'Successfully Completed'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to calendar view
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Calendar view coming soon')),
      //     );
      //   },
      //   child: const Icon(Icons.calendar_month),
      // ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(_upcomingEvents, isUpcoming: true),
          _buildEventsList(_pastEvents, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events, {required bool isUpcoming}) {
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
                  event['image'] as String,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                            event['title'] as String,
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
                              event['results'] as String,
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
                          event['date'] as String,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event['location'] as String,
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['description'] as String,
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
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Photos coming soon')),
                          // );
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