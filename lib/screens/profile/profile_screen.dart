import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'John Doe');
  final _gradeController = TextEditingController(text: 'Black Belt');
  final _genderController = TextEditingController(text: 'Male');
  final _dobController = TextEditingController(text: '1990-01-01');
  final _addressLine1Controller = TextEditingController(text: '123 Main St');
  final _addressLine2Controller = TextEditingController(text: 'Apt 4B');
  final _cityController = TextEditingController(text: 'New York');
  final _stateController = TextEditingController(text: 'NY');
  final _countryController = TextEditingController(text: 'USA');
  final _zipCodeController = TextEditingController(text: '10001');
  final _joiningDateController = TextEditingController(text: '2020-01-01');
  final _passportController = TextEditingController(text: 'A1234567');
  final _bloodGroupController = TextEditingController(text: 'O+');
  final _roleController = TextEditingController(text: 'Student');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _gradeController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    _joiningDateController.dispose();
    _passportController.dispose();
    _bloodGroupController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save logic
      _toggleEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _toggleEdit,
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
          ),
          if (_isEditing)
            IconButton(
              onPressed: _handleSave,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Personal Information',
                  children: [
                    _buildTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                    ),
                    _buildTextField(
                      label: 'Grade',
                      controller: _gradeController,
                    ),
                    _buildTextField(
                      label: 'Gender',
                      controller: _genderController,
                    ),
                    _buildTextField(
                      label: 'Date of Birth',
                      controller: _dobController,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Contact Information',
                  children: [
                    _buildTextField(
                      label: 'Address Line 1',
                      controller: _addressLine1Controller,
                    ),
                    _buildTextField(
                      label: 'Address Line 2',
                      controller: _addressLine2Controller,
                    ),
                    _buildTextField(
                      label: 'City',
                      controller: _cityController,
                    ),
                    _buildTextField(
                      label: 'State',
                      controller: _stateController,
                    ),
                    _buildTextField(
                      label: 'Country',
                      controller: _countryController,
                    ),
                    _buildTextField(
                      label: 'ZIP Code',
                      controller: _zipCodeController,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Additional Information',
                  children: [
                    _buildTextField(
                      label: 'Date of Joining',
                      controller: _joiningDateController,
                    ),
                    _buildTextField(
                      label: 'Passport Number',
                      controller: _passportController,
                    ),
                    _buildTextField(
                      label: 'Blood Group',
                      controller: _bloodGroupController,
                    ),
                    _buildTextField(
                      label: 'Role',
                      controller: _roleController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              if (_isEditing)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _fullNameController.text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _gradeController.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
} 