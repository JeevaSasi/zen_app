import 'package:flutter/material.dart';
import 'package:zen_app/screens/profile/profile_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/menu/events_page.dart';
import 'screens/menu/gallery_page.dart';
import 'screens/menu/team_page.dart';
import 'screens/menu/workouts_page.dart';
import 'screens/menu/centers_page.dart';
import 'screens/menu/contact_page.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/admin/add_event_screen.dart';
import 'screens/admin/add_workout_screen.dart';
import 'screens/admin/add_team_member_screen.dart';
import 'screens/admin/add_center_screen.dart';
import 'screens/admin/mark_attendance_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/store/product_list_screen.dart';
import 'screens/store/product_details_screen.dart';
import 'screens/store/cart_screen.dart';
import 'screens/store/checkout_screen.dart';
import 'screens/store/order_success_screen.dart';
import 'screens/store/order_history_screen.dart';
import 'screens/store/order_details_screen.dart';
import 'screens/admin/add_product_screen.dart';
import 'screens/admin/manage_orders_screen.dart';
import 'screens/store/payment_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zen Karate School',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/events': (context) => const EventsPage(),
        '/gallery': (context) => const GalleryPage(),
        '/team': (context) => const TeamPage(),
        '/workouts': (context) => const WorkoutsPage(),
        '/centers': (context) => const CentersPage(),
        '/contact': (context) => const ContactPage(),
        '/notifications': (context) => const NotificationsScreen(),
        '/add-event': (context) => const AddEventScreen(),
        '/add-workout': (context) => const AddWorkoutScreen(),
        '/add-team-member': (context) => const AddTeamMemberScreen(),
        '/add-center': (context) => const AddCenterScreen(),
        '/mark-attendance': (context) => const MarkAttendanceScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/products': (context) => const ProductListScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/order-success': (context) => const OrderSuccessScreen(),
        '/order-history': (context) => const OrderHistoryScreen(),
        '/order-details': (context) => const OrderDetailsScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/manage-orders': (context) => const ManageOrdersScreen(),
        '/payment': (context) => const PaymentScreen(),
      },
    );
  }
}
