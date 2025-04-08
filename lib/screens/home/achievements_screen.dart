import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _selectedUser = 'All Users';
  
  // List of achievement data
  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 1,
      'title': 'World Karate Championship 2024',
      'description': 'Won gold medal in kata competition at the World Karate Championship 2024 held in Tokyo, Japan.',
      'level': 'International',
      'medal': 'Gold',
      'date': 'March 15, 2024',
      'student': 'John Doe',
      'colorIndex': 0,
      'icon': Icons.sports_martial_arts,
    },
    {
      'id': 2,
      'title': 'National Karate Tournament',
      'description': 'Secured silver medal in kumite competition at the National Championship.',
      'level': 'National',
      'medal': 'Silver',
      'date': 'February 22, 2024',
      'student': 'Emma Smith',
      'colorIndex': 1,
      'icon': Icons.emoji_events,
    },
    {
      'id': 3,
      'title': 'State Karate Competition',
      'description': 'Won bronze medal in team kata at the State Championship.',
      'level': 'State',
      'medal': 'Bronze',
      'date': 'January 12, 2024',
      'student': 'Mike Johnson',
      'colorIndex': 2,
      'icon': Icons.military_tech,
    },
    {
      'id': 4,
      'title': 'International Youth Championship',
      'description': 'Achieved gold medal in under-18 kumite category at the International Youth Championship.',
      'level': 'International',
      'medal': 'Gold',
      'date': 'December 10, 2023',
      'student': 'Sarah Williams',
      'colorIndex': 3,
      'icon': Icons.sports_kabaddi,
    },
    {
      'id': 5,
      'title': 'District Tournament',
      'description': 'Won first place in beginners category at the District Tournament.',
      'level': 'District',
      'medal': 'Gold',
      'date': 'November 5, 2023',
      'student': 'David Lee',
      'colorIndex': 4,
      'icon': Icons.fitness_center,
    },
  ];
  
  // Colors for achievement backgrounds
  final List<Color> _achievementColors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
    Colors.teal.shade200,
  ];
  
  List<Map<String, dynamic>> _filteredAchievements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _filteredAchievements = List.from(_achievements);
        _isLoading = false;
      });
    }
  }
  
  void _filterAchievements() {
    setState(() {
      _filteredAchievements = _achievements.where((achievement) {
        bool levelMatch = _selectedFilter == 'All' || achievement['level'] == _selectedFilter;
        bool userMatch = _selectedUser == 'All Users' || achievement['student'] == _selectedUser;
        return levelMatch && userMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        child: _buildAchievementsList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add achievement
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Achievement'),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Achievements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Level',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip('All', setState),
                      _buildFilterChip('District', setState),
                      _buildFilterChip('State', setState),
                      _buildFilterChip('National', setState),
                      _buildFilterChip('International', setState),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Student',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildUserChip('All Users', setState),
                      _buildUserChip('John Doe', setState),
                      _buildUserChip('Emma Smith', setState),
                      _buildUserChip('Mike Johnson', setState),
                      _buildUserChip('Sarah Williams', setState),
                      _buildUserChip('David Lee', setState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        _filterAchievements();
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, StateSetter setState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == label,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }

  Widget _buildUserChip(String label, StateSetter setState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedUser == label,
      onSelected: (selected) {
        setState(() {
          _selectedUser = label;
        });
      },
    );
  }

  Widget _buildAchievementsList() {
    if (_filteredAchievements.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No achievements found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your filters or add a new achievement',
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _isLoading ? 3 : _filteredAchievements.length,
      itemBuilder: (context, index) {
        final achievement = _isLoading ? {} : _filteredAchievements[index];
        final colorIndex = _isLoading ? 0 : (achievement['colorIndex'] as int? ?? 0) % _achievementColors.length;
        final icon = _isLoading ? Icons.emoji_events : (achievement['icon'] as IconData? ?? Icons.emoji_events);
        
        Color medalColor;
        if (achievement['medal'] == 'Gold') {
          medalColor = Colors.amber;
        } else if (achievement['medal'] == 'Silver') {
          medalColor = Colors.grey.shade300;
        } else {
          medalColor = Colors.brown.shade300;
        }
        
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: _achievementColors[colorIndex],
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: KarateBeltPatternPainter(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        // Icon
                        Center(
                          child: Icon(
                            icon,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        // Achievement level badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getLevelIcon(achievement['level'] ?? 'District'),
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isLoading ? 'International' : achievement['level'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _isLoading ? 'International' : achievement['level'],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: medalColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _isLoading ? 'Gold' : achievement['medal'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isLoading ? 'World Karate Championship 2024' : achievement['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLoading 
                          ? 'Won gold medal in kata competition at the World Karate Championship 2024 held in Tokyo, Japan.' 
                          : achievement['description'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            _isLoading ? 'J' : achievement['student'][0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isLoading ? 'John Doe' : achievement['student'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isLoading ? 'March 15, 2024' : achievement['date'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
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
  
  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'International':
        return Icons.public;
      case 'National':
        return Icons.flag;
      case 'State':
        return Icons.location_city;
      case 'District':
        return Icons.map;
      default:
        return Icons.emoji_events;
    }
  }
}

class KarateBeltPatternPainter extends CustomPainter {
  final Color color;
  
  KarateBeltPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    // Create a pattern that resembles karate belt stripes
    for (int i = 0; i < size.width + size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(i.toDouble(), 0),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 