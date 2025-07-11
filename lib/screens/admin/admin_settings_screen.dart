import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zen_app/services/api_service.dart';
import '../../widgets/shimmer_widget.dart';
import 'add_event_screen.dart';
import 'add_workout_screen.dart';
import 'add_team_member_screen.dart';
import 'add_center_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  List<dynamic> _events = [];
  List<dynamic> _workouts = [];
  List<dynamic> _teamMembers = [];
  List<dynamic> _centers = [];
  List<dynamic> _achievements = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _loadAllData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadUsers(),
      _loadEvents(),
      _loadWorkouts(),
      _loadTeamMembers(),
      _loadCenters(),
      _loadAchievements(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _loadUsers() async {
    final users = await ApiService().getAllUsers();
    if(users['success'] == true){
      setState(() {
        _users = users['data'];
        _filteredUsers = users['data'];
      });
    }
  }

  Future<void> _loadEvents() async {
    final events = await ApiService().getEvents();
    if(events['success'] == true){
      setState(() => _events = events['data']);
    }
  }

  Future<void> _loadWorkouts() async {
    final workouts = await ApiService().getWorkouts();
    if(workouts['success'] == true){
      setState(() => _workouts = workouts['data']);
    }
  }

  Future<void> _loadTeamMembers() async {
    final team = await ApiService().getTeamMembers();
    if(team['success'] == true){
      setState(() => _teamMembers = team['data']);
    }
  }

  Future<void> _loadCenters() async {
    final centers = await ApiService().getCentres();
    if(centers['success'] == true){
      setState(() => _centers = centers['data']);
    }
  }

  Future<void> _loadAchievements() async {
    final achievements = await ApiService().getAchievements();
    if(achievements['success'] == true){
      setState(() => _achievements = achievements['data']);
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final name = user['full_name'].toString().toLowerCase();
        final email = user['email'].toString().toLowerCase();
        final mobile = user['mobile'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || 
               email.contains(searchQuery) || 
               mobile.contains(searchQuery);
      }).toList();
    });
  }

  void _showUserDetailsDialog(Map<String, dynamic> user) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Text(
                              user['full_name'][0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['full_name'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  user['user_id'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoTile('Email', user['email']),
                            _buildInfoTile('Mobile', user['mobile']),
                            _buildInfoTile('Grade', user['grade'] ?? 'Not specified'),
                            _buildInfoTile(
                              'Gender', 
                              _getGenderText(user['gender']),
                              gender: user['gender']
                            ),
                            _buildInfoTile('Address', _formatAddress(user)),
                            _buildInfoTile('Date of Birth', user['date_of_birth'] ?? 'Not specified'),
                            _buildInfoTile('Date of Joining', user['date_of_joining'] ?? 'Not specified'),
                            _buildInfoTile('Blood Group', user['blood_group'] ?? 'Not specified'),
                            _buildInfoTile('Role', user['role'] ?? 'Not specified'),
                            _buildInfoTile('Status', user['is_active'] == '1' ? 'Active' : 'Inactive'),
                            _buildInfoTile('Admin Status', user['is_admin'] == '1' ? 'Admin' : 'User'),
                            _buildInfoTile('Profile Status', 
                              user['is_profile_updated'] == '1' ? 'Updated' : 'Not Updated'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  String _formatAddress(Map<String, dynamic> user) {
    List<String> addressParts = [];
    if (user['address_line_1'] != null) addressParts.add(user['address_line_1']);
    if (user['address_line_2'] != null) addressParts.add(user['address_line_2']);
    if (user['city'] != null) addressParts.add(user['city']);
    if (user['state_id'] != null) addressParts.add(user['state_id']);
    if (user['country_id'] != null) addressParts.add(user['country_id']);
    if (user['pincode'] != null) addressParts.add(user['pincode']);
    
    return addressParts.isEmpty ? 'Not specified' : addressParts.join(', ');
  }

  String _getGenderText(String? gender) {
    switch(gender) {
      case '1':
        return 'Male';
      case '2':
        return 'Female';
      case '3':
        return 'Others';
      default:
        return 'Not specified';
    }
  }

  Icon _getGenderIcon(String? gender) {
    switch(gender) {
      case '1':
        return const Icon(Icons.male, color: Colors.blue);
      case '2':
        return const Icon(Icons.female, color: Colors.pink);
      case '3':
        return const Icon(Icons.transgender, color: Colors.purple);
      default:
        return const Icon(Icons.person_outline, color: Colors.grey);
    }
  }

  Widget _buildInfoTile(String label, String value, {String? gender}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (label == 'Gender')
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _getGenderIcon(gender),
              ],
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: color ?? Colors.grey[700]),
          onPressed: onEdit,
        ),
        IconButton(
          icon: Icon(Icons.delete, color: color ?? Colors.grey[700]),
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildSearchBar({
    required String hintText,
    required VoidCallback onAdd,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadAllData,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Updated to include all 6 tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Settings',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelStyle: const TextStyle(color: Colors.white70),
            labelStyle: const TextStyle(color: Colors.white),
            isScrollable: true,
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Events'),
              Tab(text: 'Workouts'),
              Tab(text: 'Team'),
              Tab(text: 'Centers'),
              Tab(text: 'Achievements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersTab(),
            _buildEventsTab(),
            _buildWorkoutsTab(),
            _buildTeamTab(),
            _buildCentersTab(),
            _buildAchievementsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterUsers,
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email or mobile...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterUsers('');
                          },
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _users = [];
                      _filteredUsers = [];
                    });
                    _loadAllData();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_filteredUsers.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0, 
                          index * 10.0 * (1 - _animation.value), 
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              radius: 25,
                              child: Text(
                                user['full_name'][0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user['full_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(user['email']),
                                const SizedBox(height: 2),
                                Text(user['mobile']),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user['is_active'] == '1'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user['is_active'] == '1' ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: user['is_active'] == '1'
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () => _showUserDetailsDialog(user),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return Column(
      children: [
        _buildSearchBar(
          hintText: 'Search events...',
          onAdd: () => Navigator.pushNamed(context, '/add-event'),
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerEventsList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_events.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0,
                          index * 10.0 * (1 - _animation.value),
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  image: event['image_url'] != null
                                      ? DecorationImage(
                                          image: NetworkImage(event['image_url']),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: event['image_url'] == null
                                    ? Center(
                                        child: Icon(
                                          Icons.event,
                                          size: 48,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      )
                                    : null,
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
                                            event['type'] ?? 'Event',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        // _buildActionButtons(
                                        //   onEdit: () {
                                        //     // TODO: Implement edit event
                                        //   },
                                        //   onDelete: () {
                                        //     // TODO: Implement delete event
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      event['name'] ?? 'Untitled Event',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${event['date'] ?? 'Date TBA'} • ${event['location'] ?? 'Location TBA'}',
                                      
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
                ),
        ),
      ],
    );
  }

  Widget _buildWorkoutsTab() {
    return Column(
      children: [
        _buildSearchBar(
          hintText: 'Search workouts...',
          onAdd: () => Navigator.pushNamed(context, '/add-workout'),
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_workouts.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _workouts.length,
                    itemBuilder: (context, index) {
                      final workout = _workouts[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0,
                          index * 10.0 * (1 - _animation.value),
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              radius: 25,
                              child: const Icon(Icons.fitness_center, color: Colors.white),
                            ),
                            title: Text(
                              workout['title'] ?? 'Untitled Workout',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(workout['time'] ?? 'Duration not specified'),
                                const SizedBox(height: 2),
                                Text(workout['level'] ?? 'Level not specified'),
                              ],
                            ),
                            // trailing: _buildActionButtons(
                            //   onEdit: () {
                            //     // TODO: Implement edit workout
                            //   },
                            //   onDelete: () {
                            //     // TODO: Implement delete workout
                            //   },
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTeamTab() {
    return Column(
      children: [
        _buildSearchBar(
          hintText: 'Search team members...',
          onAdd: () => Navigator.pushNamed(context, '/add-team-member'),
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_teamMembers.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _teamMembers.length,
                    itemBuilder: (context, index) {
                      final member = _teamMembers[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0,
                          index * 10.0 * (1 - _animation.value),
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              radius: 25,
                              // need rounded image that fits the circle
                              child: member['profile_image'] != '' ? ClipOval(
                                child: Image.network(member['profile_image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ) : const Icon(Icons.person,color: Colors.white,),
                            ),
                            title: Text(
                              member['name'] ?? 'Unnamed Member',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(member['role'] ?? 'Role not specified'),
                                const SizedBox(height: 2),
                                Text(member['grade'] ?? 'Qualification not specified'),
                              ],
                            ),
                            // trailing: _buildActionButtons(
                            //   onEdit: () {
                            //     // TODO: Implement edit team member
                            //   },
                            //   onDelete: () {
                            //     // TODO: Implement delete team member
                            //   },
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCentersTab() {
    return Column(
      children: [
        _buildSearchBar(
          hintText: 'Search centers...',
          onAdd: () => Navigator.pushNamed(context, '/add-center'),
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerEventsList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_centers.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _centers.length,
                    itemBuilder: (context, index) {
                      final center = _centers[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0,
                          index * 10.0 * (1 - _animation.value),
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  image: center['image_url'] != null
                                      ? DecorationImage(
                                          image: NetworkImage(center['image_url']),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: center['image_url'] == null 
                                    ? Center(
                                        child: Icon(
                                          Icons.location_on,
                                          size: 48,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      )
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Spacer(),
                                        // _buildActionButtons(
                                        //   onEdit: () {
                                        //     // TODO: Implement edit center
                                        //   },
                                        //   onDelete: () {
                                        //     // TODO: Implement delete center
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    Text(
                                      center['name'] ?? 'Unnamed Center',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${center['address'] ?? 'Address not specified'} • ${center['contact_number'] ?? 'Phone not specified'}',
                                      
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
                ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    return Column(
      children: [
        _buildSearchBar(
          hintText: 'Search achievements...',
          onAdd: () {
            // TODO: Navigate to add achievement screen
          },
        ),
        Expanded(
          child: _isLoading 
              ? _buildShimmerEventsList()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<int>(_achievements.length),
                    padding: const EdgeInsets.all(16),
                    itemCount: _achievements.length,
                    itemBuilder: (context, index) {
                      final achievement = _achievements[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                          0.0,
                          index * 10.0 * (1 - _animation.value),
                          0.0,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  image: achievement['image_url'] != null
                                      ? DecorationImage(
                                          image: NetworkImage(achievement['image_url']),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: achievement['image_url'] == null
                                    ? Center(
                                        child: Icon(
                                          Icons.emoji_events,
                                          size: 48,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      )
                                    : null,
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
                                            achievement['level'] ?? 'Achievement',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        // _buildActionButtons(
                                        //   onEdit: () {
                                        //     // TODO: Implement edit achievement
                                        //   },
                                        //   onDelete: () {
                                        //     // TODO: Implement delete achievement
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      achievement['tournament_name'] ?? 'Untitled Achievement',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Won ${achievement['medal_type']} by ${achievement['won_by']} \n${achievement['description'] ?? 'Description not specified'} • ${achievement['tournament_date'] ?? 'Date not specified'}',
                                      
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
                ),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const ShimmerWidget.circular(width: 40, height: 40),
                title: Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerWidget.rectangular(height: 16),
                      const SizedBox(height: 8),
                      const ShimmerWidget.rectangular(height: 14, width: 150),
                    ],
                  ),
                ),
                trailing: Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerEventsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
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
                              width: 100,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 80,
                              height: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const ShimmerWidget.rectangular(height: 24),
                        const SizedBox(height: 4),
                        const ShimmerWidget.rectangular(height: 16, width: 200),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
