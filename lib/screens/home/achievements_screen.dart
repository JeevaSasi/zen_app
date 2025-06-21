import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/shimmer_widget.dart';
import '../../services/api_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _selectedUser = 'All Users';
  final ApiService _apiService = ApiService();
  
  // List of achievement data
  List<Map<String, dynamic>> _achievements = [];
  
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
    try {
      final response = await _apiService.getAchievements();
      if (mounted) {
        setState(() {
          if (response['success'] == true) {
            _achievements = List<Map<String, dynamic>>.from(response['data']);
            _filteredAchievements = List.from(_achievements);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load achievements. Please try again later.'),
          ),
        );
      }
    }
  }
  
  void _filterAchievements() {
    setState(() {
      _filteredAchievements = _achievements.where((achievement) {
        bool levelMatch = _selectedFilter == 'All' || achievement['level'] == _selectedFilter;
        bool userMatch = _selectedUser == 'All Users' || achievement['won_by'] == _selectedUser;
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
      body: _isLoading 
          ? _buildShimmerAchievements()
          : _buildAchievementsList(),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    // Get unique levels and users from achievements
    final levels = _achievements.map((a) => a['level'] as String).toSet().toList();
    final users = _achievements.map((a) => a['won_by'] as String).toSet().toList();
    
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
                      ...levels.map((level) => _buildFilterChip(level, setState)),
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
                      ...users.map((user) => _buildUserChip(user, setState)),
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
      itemCount: _filteredAchievements.length,
      itemBuilder: (context, index) {
        final achievement = _filteredAchievements[index];
        final colorIndex = index % _achievementColors.length;
        
        Color medalColor;
        switch (achievement['medal_type']) {
          case 'Gold':
            medalColor = Colors.amber;
            break;
          case 'Silver':
            medalColor = Colors.grey.shade300;
            break;
          case 'Bronze':
            medalColor = Colors.brown.shade300;
            break;
          default:
            medalColor = Colors.grey.shade300;
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
                            Icons.emoji_events,
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
                                  _getLevelIcon(achievement['level']),
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  achievement['level'],
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
                            achievement['level'],
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
                            achievement['medal_type'],
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
                      achievement['tournament_name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement['description'],
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
                            achievement['won_by'][0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          achievement['won_by'],
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
                          achievement['tournament_date'],
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

  Widget _buildShimmerAchievements() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level and medal badges
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Title
                      const ShimmerWidget.rectangular(
                        width: double.infinity,
                        height: 24,
                      ),
                      const SizedBox(height: 8),
                      // Description
                      const ShimmerWidget.rectangular(
                        width: double.infinity,
                        height: 40,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      // Footer
                      Row(
                        children: [
                          const ShimmerWidget.circular(width: 32, height: 32),
                          const SizedBox(width: 8),
                          const ShimmerWidget.rectangular(width: 100, height: 16),
                          const Spacer(),
                          const ShimmerWidget.rectangular(width: 80, height: 16),
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
    );
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