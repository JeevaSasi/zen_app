import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _apiService = ApiService();
  String _userName = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('full_name') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileCard(context),
              const SizedBox(height: 24),
              _buildMenuSection(context),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('View Profile'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms & Conditions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  //launch url
                  launchUrl(Uri.parse('https://www.zenkarateschoolofindia.com/terms-conditions.html'));
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.rule_outlined),
                title: const Text('Data & Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  launchUrl(Uri.parse('https://www.zenkarateschoolofindia.com/privacy-policy.html'));
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () => _logout(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                title: const Text('Deactivate Account', style: TextStyle(color: Colors.red)),
                onTap: () => _deactivate(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Future<void> _deactivate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text('Are you sure you want to deactivate your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your account will be deactivated after 30 days of inactivity.'),
              ),
            ),
            Navigator.pop(context, true),
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // TODO: Implement deactivate API
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() => _isLoading = true);
      
      final response = await _apiService.logout();
      
      setState(() => _isLoading = false);
      
      if (context.mounted) {
        if (response['success'] == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Failed to logout. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 