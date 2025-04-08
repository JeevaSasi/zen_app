import 'package:flutter/material.dart';
import 'dart:io';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddTeamMemberScreen extends StatefulWidget {
  const AddTeamMemberScreen({super.key});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? _imagePath;
  bool _isLoading = false;
  
  String _role = 'Instructor';
  final List<String> _roles = [
    'Instructor',
    'Assistant Instructor',
    'Master',
    'Grandmaster',
    'Staff',
    'Administrator',
  ];
  
  String _belt = 'Black Belt';
  final List<String> _belts = [
    'White Belt',
    'Yellow Belt',
    'Orange Belt',
    'Green Belt',
    'Blue Belt',
    'Purple Belt',
    'Brown Belt',
    'Red Belt',
    'Black Belt',
    '2nd Dan Black Belt',
    '3rd Dan Black Belt',
    '4th Dan Black Belt',
    '5th Dan Black Belt',
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team member added successfully')),
        );
        Navigator.pop(context);
      });
    }
  }
  
  Future<void> _selectImage() async {
    // Simulate picking an image
    setState(() {
      _imagePath = 'Selected profile image';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected successfully')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Member'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Role',
                      value: _role,
                      items: _roles,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _role = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Belt Rank',
                      value: _belt,
                      items: _belts,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _belt = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Position/Title',
                controller: _positionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter position';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Years of Experience',
                controller: _experienceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter years of experience';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _bioController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Biography',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    hintText: 'Brief description about the team member',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter biography';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone (optional)',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              _buildSpecialtiesSection(),
              const SizedBox(height: 24),
              _buildCertificationsSection(),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Add Team Member',
                onPressed: _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePicker() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            child: _imagePath != null
                ? const Icon(Icons.check, size: 40, color: Colors.green)
                : const Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _selectImage,
            icon: const Icon(Icons.add_a_photo),
            label: Text(_imagePath != null ? 'Change Image' : 'Add Profile Image'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(label),
        ),
      ),
    );
  }
  
  final List<String> _specialties = [
    'Kata',
    'Kumite',
  ];
  
  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Specialties',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            ..._specialties.map(_buildSpecialtyChip).toList(),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('Add Specialty'),
              onPressed: _addSpecialty,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSpecialtyChip(String specialty) {
    return Chip(
      label: Text(specialty),
      onDeleted: () {
        setState(() {
          _specialties.remove(specialty);
        });
      },
    );
  }
  
  void _addSpecialty() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Specialty'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'E.g., Sparring, Self-defense',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final specialty = controller.text.trim();
              if (specialty.isNotEmpty) {
                setState(() {
                  _specialties.add(specialty);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
  
  final List<Certification> _certifications = [];
  
  Widget _buildCertificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Certifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _certifications.length + 1, // +1 for "Add certification" button
          itemBuilder: (context, index) {
            if (index == _certifications.length) {
              return TextButton.icon(
                onPressed: _addCertification,
                icon: const Icon(Icons.add),
                label: const Text('Add Certification'),
              );
            }
            
            final certification = _certifications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            certification.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Issued by: ${certification.issuedBy}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Year: ${certification.year}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editCertification(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _removeCertification(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  void _addCertification() {
    _showCertificationDialog();
  }
  
  void _editCertification(int index) {
    _showCertificationDialog(index: index, certification: _certifications[index]);
  }
  
  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
  }
  
  void _showCertificationDialog({int? index, Certification? certification}) {
    final nameController = TextEditingController(text: certification?.name ?? '');
    final issuedByController = TextEditingController(text: certification?.issuedBy ?? '');
    final yearController = TextEditingController(
      text: certification?.year != null ? certification!.year.toString() : '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(certification == null ? 'Add Certification' : 'Edit Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Certification Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: issuedByController,
              decoration: const InputDecoration(
                labelText: 'Issued By',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final issuedBy = issuedByController.text.trim();
              final yearText = yearController.text.trim();
              final year = int.tryParse(yearText);
              
              if (name.isNotEmpty && issuedBy.isNotEmpty && year != null) {
                setState(() {
                  if (index != null) {
                    _certifications[index] = Certification(
                      name: name,
                      issuedBy: issuedBy,
                      year: year,
                    );
                  } else {
                    _certifications.add(Certification(
                      name: name,
                      issuedBy: issuedBy,
                      year: year,
                    ));
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}

class Certification {
  final String name;
  final String issuedBy;
  final int year;
  
  Certification({
    required this.name,
    required this.issuedBy,
    required this.year,
  });
} 