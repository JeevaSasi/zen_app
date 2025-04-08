import 'package:flutter/material.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> workouts = [
      {
        'title': 'Beginner Kata Practice',
        'duration': '30 minutes',
        'level': 'Beginner',
        'description': 'Learn and practice fundamental kata movements including blocks, punches, and stances.',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
      },
      {
        'title': 'Kumite Drills',
        'duration': '45 minutes',
        'level': 'Intermediate',
        'description': 'Practice sparring techniques with a partner, focusing on timing, distance, and control.',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
      },
      {
        'title': 'Advanced Kata',
        'duration': '1 hour',
        'level': 'Advanced',
        'description': 'Work on advanced kata forms with complex movements and transitions.',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
      },
      {
        'title': 'Strength & Conditioning',
        'duration': '45 minutes',
        'level': 'All Levels',
        'description': 'Build strength, endurance, and flexibility with exercises tailored for karate practitioners.',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
      },
      {
        'title': 'Self-Defense Techniques',
        'duration': '1 hour',
        'level': 'Intermediate',
        'description': 'Learn practical self-defense applications from traditional karate techniques.',
        'image': 'https://zenkarateschoolofindia.com/images/logo.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   onPressed: () {
          //     // Show filter dialog
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Filters coming soon')),
          //     );
          //   },
          // ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Navigate to workout details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Workout details coming soon')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        workout['image'] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout['title'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                workout['duration'] as String,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getLevelColor(workout['level'] as String).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  workout['level'] as String,
                                  style: TextStyle(
                                    color: _getLevelColor(workout['level'] as String),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            workout['description'] as String,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Start workout
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Workout will start soon')),
                                );
                              },
                              child: const Text('START WORKOUT'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
} 