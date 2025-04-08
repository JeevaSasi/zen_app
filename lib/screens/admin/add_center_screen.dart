import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddCenterScreen extends StatefulWidget {
  const AddCenterScreen({super.key});

  @override
  State<AddCenterScreen> createState() => _AddCenterScreenState();
}

class _AddCenterScreenState extends State<AddCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _imagePath;
  bool _isLoading = false;
  
  List<String> _selectedAmenities = [];
  final List<String> _allAmenities = [
    'Changing Rooms',
    'Showers',
    'Water Fountain',
    'Parking',
    'Equipment Store',
    'Air Conditioning',
    'Spectator Area',
    'Wheelchair Access',
    'WiFi',
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
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
          const SnackBar(content: Text('Center added successfully')),
        );
        Navigator.pop(context);
      });
    }
  }
  
  Future<void> _selectImage() async {
    // Simulate picking an image
    setState(() {
      _imagePath = 'Selected center image';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected successfully')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Training Center'),
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
                label: 'Center Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter center name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomTextField(
                label: 'Address Line 1',
                controller: _addressLine1Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Address Line 2 (optional)',
                controller: _addressLine2Controller,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: CustomTextField(
                      label: 'City',
                      controller: _cityController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: 'State',
                      controller: _stateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: 'ZIP',
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ZIP';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Website (optional)',
                controller: _websiteController,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    hintText: 'Brief description about the center',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildAmenitiesSection(),
              const SizedBox(height: 16),
              _buildClassScheduleSection(),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Add Center',
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
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: _imagePath != null
                ? const Center(
                    child: Icon(Icons.check, size: 40, color: Colors.green),
                  )
                : const Center(
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                  ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _selectImage,
            icon: const Icon(Icons.add_a_photo),
            label: Text(_imagePath != null ? 'Change Image' : 'Add Center Image'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Amenities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allAmenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  final List<ClassSchedule> _schedules = [];
  
  Widget _buildClassScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Class Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _schedules.length + 1, // +1 for "Add class" button
          itemBuilder: (context, index) {
            if (index == _schedules.length) {
              return TextButton.icon(
                onPressed: _addClass,
                icon: const Icon(Icons.add),
                label: const Text('Add Class'),
              );
            }
            
            final schedule = _schedules[index];
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
                            schedule.className,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${schedule.day} | ${schedule.startTime} - ${schedule.endTime}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Instructor: ${schedule.instructor}',
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
                      onPressed: () => _editClass(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _removeClass(index),
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
  
  void _addClass() {
    _showClassDialog();
  }
  
  void _editClass(int index) {
    _showClassDialog(index: index, schedule: _schedules[index]);
  }
  
  void _removeClass(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
  }
  
  void _showClassDialog({int? index, ClassSchedule? schedule}) {
    final classNameController = TextEditingController(text: schedule?.className ?? '');
    final instructorController = TextEditingController(text: schedule?.instructor ?? '');
    final dayController = TextEditingController(text: schedule?.day ?? '');
    final startTimeController = TextEditingController(text: schedule?.startTime ?? '');
    final endTimeController = TextEditingController(text: schedule?.endTime ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule == null ? 'Add Class' : 'Edit Class'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classNameController,
                decoration: const InputDecoration(
                  labelText: 'Class Name',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dayController,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  hintText: 'e.g., Monday, Tuesday',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        hintText: 'e.g., 9:00 AM',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        hintText: 'e.g., 10:30 AM',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final className = classNameController.text.trim();
              final instructor = instructorController.text.trim();
              final day = dayController.text.trim();
              final startTime = startTimeController.text.trim();
              final endTime = endTimeController.text.trim();
              
              if (className.isNotEmpty && 
                  instructor.isNotEmpty && 
                  day.isNotEmpty && 
                  startTime.isNotEmpty && 
                  endTime.isNotEmpty) {
                setState(() {
                  if (index != null) {
                    _schedules[index] = ClassSchedule(
                      className: className,
                      instructor: instructor,
                      day: day,
                      startTime: startTime,
                      endTime: endTime,
                    );
                  } else {
                    _schedules.add(ClassSchedule(
                      className: className,
                      instructor: instructor,
                      day: day,
                      startTime: startTime,
                      endTime: endTime,
                    ));
                  }
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}

class ClassSchedule {
  final String className;
  final String instructor;
  final String day;
  final String startTime;
  final String endTime;
  
  ClassSchedule({
    required this.className,
    required this.instructor,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
} 