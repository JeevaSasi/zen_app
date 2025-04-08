import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _level = 'Beginner';
  final List<String> _levels = [
    'Beginner', 
    'Intermediate', 
    'Advanced', 
    'All Levels'
  ];
  
  String _type = 'Kata Practice';
  final List<String> _types = [
    'Kata Practice',
    'Kumite Drills',
    'Strength & Conditioning',
    'Flexibility',
    'Self-Defense Techniques',
    'Warm-ups & Cool-downs',
  ];
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
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
          const SnackBar(content: Text('Workout created successfully')),
        );
        Navigator.pop(context);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Workout Title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Workout Type',
                      value: _type,
                      items: _types,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _type = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Difficulty Level',
                      value: _level,
                      items: _levels,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _level = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Duration (e.g., 30 minutes)',
                controller: _durationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    hintText: 'Include a detailed breakdown of the workout components',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter workout description';
                    }
                    return null;
                  },
                ),
              ),
              _buildExerciseSection(),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Workout',
                onPressed: _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
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
  
  final List<Exercise> _exercises = [
    Exercise(name: 'Warm-up', duration: '5 minutes'),
    Exercise(name: 'Kata repetition', duration: '15 minutes'),
    Exercise(name: 'Cool-down stretches', duration: '5 minutes'),
  ];
  
  Widget _buildExerciseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Exercises',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exercises.length + 1, // +1 for "Add exercise" button
          itemBuilder: (context, index) {
            if (index == _exercises.length) {
              return TextButton.icon(
                onPressed: _addExercise,
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
              );
            }
            
            final exercise = _exercises[index];
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
                            exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            exercise.duration,
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
                      onPressed: () => _editExercise(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _removeExercise(index),
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
  
  void _addExercise() {
    _showExerciseDialog();
  }
  
  void _editExercise(int index) {
    _showExerciseDialog(index: index, exercise: _exercises[index]);
  }
  
  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }
  
  void _showExerciseDialog({int? index, Exercise? exercise}) {
    final nameController = TextEditingController(text: exercise?.name ?? '');
    final durationController = TextEditingController(text: exercise?.duration ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise == null ? 'Add Exercise' : 'Edit Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration',
                hintText: 'e.g., 10 minutes, 5 sets',
              ),
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
              final duration = durationController.text.trim();
              
              if (name.isNotEmpty && duration.isNotEmpty) {
                setState(() {
                  if (index != null) {
                    _exercises[index] = Exercise(
                      name: name,
                      duration: duration,
                    );
                  } else {
                    _exercises.add(Exercise(
                      name: name,
                      duration: duration,
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

class Exercise {
  final String name;
  final String duration;
  
  Exercise({
    required this.name,
    required this.duration,
  });
} 