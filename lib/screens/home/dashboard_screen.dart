import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/shimmer_widget.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifications/notifications_screen.dart';
import '../notifications/add_notification_screen.dart';
import '../../services/api_service.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  int _notificationCount = 5;
  String _selectedMedalFilter = 'All';
  String _selectedAttendanceFilter = 'Month';
  String _userName = 'User';
  final ApiService _apiService = ApiService();

  final List<String> _galleryImages = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      // Load user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isAdmin = prefs.getBool('isAdmin') ?? false;
      final userMobile = prefs.getString('userMobile') ?? '';
      final fullName = prefs.getString('full_name') ?? '';
      String name = fullName.isEmpty ? 'User' : fullName;

      // Load gallery images
      final allImages = await _apiService.getGalleryImages();
      final randomImages = _apiService.getRandomImages(allImages, 5);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAdmin = isAdmin;
          _userName = name;
          _galleryImages.clear();
          _galleryImages.addAll(randomImages);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   automaticallyImplyLeading: false,
          //   floating: true,
          //   snap: true,
          //   backgroundColor: Theme.of(context).colorScheme.secondary,
          //   elevation: 0,
          //   centerTitle: false,
          //   title: Text(
          //     'Home',
          //     style: TextStyle(
          //       color: Theme.of(context).colorScheme.primary,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 25,
          //     ),
          //   ),
          //   actions: [
          //     if (_isAdmin)
          //       IconButton(
          //         icon: Icon(
          //           Icons.add_alert,
          //           color: Theme.of(context).colorScheme.primary,
          //         ),
          //         tooltip: 'Add Notification',
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const AddNotificationScreen(),
          //             ),
          //           );
          //         },
          //       ),
          //     // Stack(
          //     //   alignment: Alignment.center,
          //     //   children: [
          //     //     IconButton(
          //     //       icon: Icon(Icons.notifications,
          //     //           color: Theme.of(context).colorScheme.primary),
          //     //       onPressed: () {
          //     //         Navigator.push(
          //     //           context,
          //     //           MaterialPageRoute(
          //     //             builder: (context) => const NotificationsScreen(),
          //     //           ),
          //     //         );
          //     //       },
          //     //     ),
          //     //     if (_notificationCount > 0)
          //     //       Positioned(
          //     //         top: 10,
          //     //         right: 10,
          //     //         child: Container(
          //     //           padding: const EdgeInsets.all(2),
          //     //           decoration: BoxDecoration(
          //     //             color: Colors.red,
          //     //             borderRadius: BorderRadius.circular(10),
          //     //           ),
          //     //           constraints: const BoxConstraints(
          //     //             minWidth: 16,
          //     //             minHeight: 16,
          //     //           ),
          //     //           child: Text(
          //     //             '$_notificationCount',
          //     //             style: const TextStyle(
          //     //               color: Colors.white,
          //     //               fontSize: 10,
          //     //               fontWeight: FontWeight.bold,
          //     //             ),
          //     //             textAlign: TextAlign.center,
          //     //           ),
          //     //         ),
          //     //       ),
          //     //   ],
          //     // ),
          //   ],
          // ),
          SliverToBoxAdapter(
            child: _isLoading 
                ? _buildShimmerDashboard()
                : Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),
                        const SizedBox(height: 16),
                        if (_isAdmin)
                          SizedBox(height: 70, child: _buildActionButtons()),
                        if (_isAdmin) const SizedBox(height: 16),
                        _buildGallerySection(),
                        const SizedBox(height: 16),
                        _buildMenuGrids(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        _buildActionButton(
          Icons.add_circle_outline,
          'Add Event',
          () => Navigator.pushNamed(context, '/add-event'),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          Icons.fitness_center_outlined,
          'Add Workout',
          () => Navigator.pushNamed(context, '/add-workout'),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          Icons.person_add_outlined,
          'Add Member',
          () => Navigator.pushNamed(context, '/add-team-member'),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          Icons.how_to_reg,
          'Mark Attendance',
          () => Navigator.pushNamed(context, '/mark-attendance'),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return  InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $_userName!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to Zen Karate School',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrids() {
    final menuItems = [
      {
        'title': 'My Profile',
        'icon': Icons.person,
        'color': Colors.blue,
        'route': '/profile',
      },
      {
        'title': 'Events',
        'icon': Icons.event,
        'color': Colors.orange,
        'route': '/events',
      },
      {
        'title': 'Our Team',
        'icon': Icons.people,
        'color': Colors.green,
        'route': '/team',
      },
      {
        'title': 'Workouts',
        'icon': Icons.fitness_center,
        'color': Colors.red,
        'route': '/workouts',
      },
      {
        'title': 'Our Centers',
        'icon': Icons.location_on,
        'color': Colors.purple,
        'route': '/centers',
      },
      {
        'title': 'Contact Us',
        'icon': Icons.contact_phone,
        'color': Colors.teal,
        'route': '/contact',
      },
      if (_isAdmin) ...[
        {
          'title': 'Add Product',
          'icon': Icons.add_shopping_cart,
          'color': Colors.red,
          'route': '/add-product',
        },
        {
          'title': 'Manage Orders',
          'icon': Icons.shopping_bag,
          'color': Colors.orange,
          'route': '/manage-orders',
        },
      ],
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item['route'] as String);
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    (item['color'] as Color).withOpacity(0.7),
                    (item['color'] as Color),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      item['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gallery',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/gallery');
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: FlutterCarousel(
            options: CarouselOptions(
              height: 180,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: _galleryImages.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/gallery');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/products'),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 120,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue to',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Online Store',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            'Shop for karate gear and accessories',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalCountSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Medal Count',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedMedalFilter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(
                        value: 'District', child: Text('District')),
                    DropdownMenuItem(value: 'State', child: Text('State')),
                    DropdownMenuItem(
                      value: 'International',
                      child: Text('International'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedMedalFilter = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 15,
                          color: Colors.yellow[700],
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 8,
                          color: Colors.brown,
                          width: 16,
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Gold');
                            case 1:
                              return const Text('Silver');
                            case 2:
                              return const Text('Bronze');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedAttendanceFilter,
                  items: const [
                    DropdownMenuItem(value: 'Month', child: Text('Month')),
                    DropdownMenuItem(value: 'Year', child: Text('Year')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedAttendanceFilter = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 90),
                        const FlSpot(1, 85),
                        const FlSpot(2, 95),
                        const FlSpot(3, 100),
                        const FlSpot(4, 88),
                        const FlSpot(5, 92),
                        const FlSpot(6, 96),
                      ],
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          if (value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            const ShimmerWidget.rectangular(width: 200, height: 32),
            const SizedBox(height: 4),
            const ShimmerWidget.rectangular(width: 250, height: 20),
            const SizedBox(height: 16),
            
            // Admin Action Buttons (if admin)
            if (_isAdmin) ...[
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Gallery Section
            const ShimmerWidget.rectangular(width: 100, height: 24),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Menu Grids
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _isAdmin ? 8 : 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
