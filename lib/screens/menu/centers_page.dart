import 'package:flutter/material.dart';

class CentersPage extends StatelessWidget {
  const CentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> centers = [
      {
        'name': 'Zen Karate School - Main Center',
        'address': '123 MG Road, Chennai, Tamil Nadu 600001',
        'phone': '+91 9876543210',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
        'classes': 'All Levels, Daily 6 AM - 9 PM',
        'instructors': 5,
      },
      {
        'name': 'Zen Karate School - North Campus',
        'address': '45 Anna Nagar, Chennai, Tamil Nadu 600040',
        'phone': '+91 9876543211',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
        'classes': 'Beginner & Intermediate, Daily 8 AM - 8 PM',
        'instructors': 3,
      },
      {
        'name': 'Zen Karate School - South Center',
        'address': '78 OMR Road, Chennai, Tamil Nadu 600119',
        'phone': '+91 9876543212',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
        'classes': 'All Levels, Daily 7 AM - 9 PM',
        'instructors': 4,
      },
      {
        'name': 'Zen Karate School - Advanced Training',
        'address': '22 ECR Road, Chennai, Tamil Nadu 600041',
        'phone': '+91 9876543213',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
        'classes': 'Advanced Only, By Appointment',
        'instructors': 2,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Centers'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: centers.length,
        itemBuilder: (context, index) {
          final center = centers[index];
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        center['image'] as String,
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
                          Text(
                            center['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  center['address'] as String,
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
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                center['phone'] as String,
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
                              const Icon(Icons.schedule,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  center['classes'] as String,
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
                              const Icon(Icons.people,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${center['instructors']} Instructors',
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
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Navigate to map
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Map view coming soon')),
                                  );
                                },
                                icon: const Icon(Icons.map),
                                label: const Text('VIEW MAP'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () {
                                  // Call center
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Calling feature coming soon')),
                                  );
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
              ));
        },
      ),
    );
  }
}
