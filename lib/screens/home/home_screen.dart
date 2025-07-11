import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'analytics_screen.dart';
import 'achievements_screen.dart';
import '../profile/more_screen.dart';
import '../admin/admin_settings_screen.dart';
import '../store/order_history_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isAdmin = false;
  
  List<Widget>? _screens;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }
  
  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAdmin = prefs.getBool('isAdmin') ?? false;
    
    setState(() {
      _isAdmin = isAdmin;
      
      // Define screens based on admin status
      _screens = [
        const DashboardScreen(),
        // const AnalyticsScreen(),
        // const OrderHistoryScreen(),
        const AchievementsScreen(),
        const MoreScreen(),
        if (_isAdmin) const AdminSettingsScreen(),
      ];
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens ?? [
            const DashboardScreen(),
            // const AnalyticsScreen(),
            // const OrderHistoryScreen(),
            const AchievementsScreen(),
            const MoreScreen(),
            if (_isAdmin) const AdminSettingsScreen(),
          ],
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: CrystalNavigationBar(
            currentIndex: _currentIndex,
            itemPadding: const EdgeInsets.all(6),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            indicatorColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.black,
            borderRadius: 15,
            enableFloatingNavBar: true,
            outlineBorderColor: Colors.white.withOpacity(0.3),
            borderWidth: 1.5,
            items: [
              CrystalNavigationBarItem(
                icon: Icons.home,
                unselectedIcon: Icons.home_outlined,
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
              // CrystalNavigationBarItem(
              //   icon: Icons.analytics,
              //   unselectedIcon: Icons.analytics_outlined,
              //   selectedColor: Theme.of(context).colorScheme.primary,
              // ),
              //  CrystalNavigationBarItem(
              //   icon: Icons.shopping_cart,
              //   unselectedIcon: Icons.shopping_cart_outlined,
              //   selectedColor: Theme.of(context).colorScheme.primary,
              // ),
              CrystalNavigationBarItem(
                icon: Icons.emoji_events,
                unselectedIcon: Icons.emoji_events_outlined,
                selectedColor: Theme.of(context).colorScheme.primary,
                // badge:const Badge(
                //   label: Text(
                //     "3",
                //     style: TextStyle(color: Colors.white, fontSize: 10),
                //   ),
                // ),
              ),
              CrystalNavigationBarItem(
                icon: Icons.more_horiz,
                unselectedIcon: Icons.more_horiz_outlined,
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
              if (_isAdmin)
                CrystalNavigationBarItem(
                  icon: Icons.admin_panel_settings,
                  unselectedIcon: Icons.admin_panel_settings_outlined,
                  selectedColor: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }
} 