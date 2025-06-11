import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/shimmer_widget.dart';
import '../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  final _apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  int _selectedGender = 1; // 1-male, 2-female, 3-others
  final _dobController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateIdController = TextEditingController();
  final _countryIdController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _passportController = TextEditingController();
  final _bloodGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateIdController.dispose();
    _countryIdController.dispose();
    _pincodeController.dispose();
    _passportController.dispose();
    _bloodGroupController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _apiService.getProfile();
      if (response['success'] == true) {
        final userData = response['data'];
        setState(() {
          _fullNameController.text = userData['full_name'] ?? '';
          _selectedGender = userData['gender'] ?? 1;
          _dobController.text = userData['date_of_birth'] ?? '';
          _addressLine1Controller.text = userData['address_line_1'] ?? '';
          _addressLine2Controller.text = userData['address_line_2'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _stateIdController.text = userData['state_id']?.toString() ?? '';
          _countryIdController.text = userData['country_id']?.toString() ?? '';
          _pincodeController.text = userData['pincode']?.toString() ?? '';
          _passportController.text = userData['passport_number'] ?? '';
          _bloodGroupController.text = userData['blood_group'] ?? '';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? 'Failed to load profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final response = await _apiService.updateProfile(
          fullName: _fullNameController.text,
          gender: _selectedGender,
          addressLine1: _addressLine1Controller.text,
          addressLine2: _addressLine2Controller.text,
          city: _cityController.text,
          stateId: int.parse(_stateIdController.text),
          countryId: int.parse(_countryIdController.text),
          pincode: int.parse(_pincodeController.text),
          dateOfBirth: _dobController.text,
          passportNumber: _passportController.text,
          bloodGroup: _bloodGroupController.text,
        );

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Failed to update profile')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _isSaving ? null : _toggleEdit,
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
            ),
          if (_isEditing)
            IconButton(
              onPressed: _isSaving ? null : _handleSave,
              icon: _isSaving 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            ),
        ],
      ),
      body: _isLoading 
          ? _buildShimmerProfile()
          : SingleChildScrollView(
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildGenderSelection(),
                        _buildTextField(
                          label: 'Date of Birth',
                          controller: _dobController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of birth is required';
                            }
                            // Add date format validation if needed
                            return null;
                          },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Address Line 2',
                          controller: _addressLine2Controller,
                        ),
                        _buildTextField(
                          label: 'City',
                          controller: _cityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'State ID',
                          controller: _stateIdController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'State ID is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid state ID';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Country ID',
                          controller: _countryIdController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Country ID is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid country ID';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'PIN Code',
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'PIN code is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid PIN code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Additional Information',
                      children: [
                        _buildTextField(
                          label: 'Passport Number',
                          controller: _passportController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Passport number is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Blood Group',
                          controller: _bloodGroupController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Blood group is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Male'),
                value: 1,
                groupValue: _selectedGender,
                onChanged: _isEditing
                    ? (value) {
                        setState(() => _selectedGender = value!);
                      }
                    : null,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Female'),
                value: 2,
                groupValue: _selectedGender,
                onChanged: _isEditing
                    ? (value) {
                        setState(() => _selectedGender = value!);
                      }
                    : null,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Others'),
                value: 3,
                groupValue: _selectedGender,
                onChanged: _isEditing
                    ? (value) {
                        setState(() => _selectedGender = value!);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Shimmer
            Center(
              child: Column(
                children: [
                  const ShimmerWidget.circular(width: 100, height: 100),
                  const SizedBox(height: 16),
                  const ShimmerWidget.rectangular(width: 150, height: 24),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Personal Information Section
            const ShimmerWidget.rectangular(width: 200, height: 24),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerWidget.rectangular(width: 100, height: 16),
                        const SizedBox(height: 8),
                        const ShimmerWidget.rectangular(height: 50),
                      ],
                    ),
                  )),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Contact Information Section
            const ShimmerWidget.rectangular(width: 200, height: 24),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(6, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerWidget.rectangular(width: 100, height: 16),
                        const SizedBox(height: 8),
                        const ShimmerWidget.rectangular(height: 50),
                      ],
                    ),
                  )),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Additional Information Section
            const ShimmerWidget.rectangular(width: 200, height: 24),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(2, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerWidget.rectangular(width: 100, height: 16),
                        const SizedBox(height: 8),
                        const ShimmerWidget.rectangular(height: 50),
                      ],
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 