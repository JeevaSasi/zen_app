import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teamMembers = [
      {
        'name': 'Sensei Karthikeyan Natarajan',
        'role': 'Chief Instructor',
        'dan': '7th Dan Black Belt',
        'image': 'https://zenkarateschoolofindia.com/images/team/master.jpeg',
        'description': 'Master Tanaka has over 30 years of experience in Karate and has won multiple international championships.',
      },
      {
        'name': 'Sensei Dharsan Dayanand',
        'role': 'Senior Instructor',
        'dan': '5th Dan Black Belt',
        'image': 'https://zenkarateschoolofindia.com/images/team/dharsan-dayanand.jpeg',
        'description': 'Sensei Rani specializes in kata and has represented India in the Asian Games.',
      },
      {
        'name': 'Sempei Pritheivraj Kartikeyan',
        'role': 'Junior Instructor',
        'dan': '3rd Dan Black Belt',
        'image': 'https://zenkarateschoolofindia.com/images/team/pritheive.jpeg',
        'description': 'Sensei Rajesh focuses on kumite training and has been with Zen Karate School for 10 years.',
      },
      {
        'name': 'Jeeva Sasikumar',
        'role': 'Assistant Instructor',
        'dan': '2nd Dan Black Belt',
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB7_F4w3RB9F-dQBNCQ25P3GA6YOwxoVZJNQ&s',
        'description': 'Arjun is a former national champion and specializes in training children.',
      },
      {
        'name': 'Kavya',
        'role': 'Assistant Instructor',
        'dan': '1st Dan Black Belt',
        'image': 'https://images.stockcake.com/public/6/9/c/69cdefee-f30b-483e-bd1c-438325484fb0_large/karate-girl-posing-stockcake.jpg',
        'description': 'Priya joined the teaching team after winning the state championship three years in a row.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Team'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          final member = teamMembers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(member['image'] as String),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member['role'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            member['dan'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          member['description'] as String,
                          style: const TextStyle(fontSize: 14),
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