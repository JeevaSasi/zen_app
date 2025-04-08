import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  // Mock student data
  final List<Map<String, dynamic>> _students = [
    {'id': 1, 'name': 'John Doe', 'present': false},
    {'id': 2, 'name': 'Jane Smith', 'present': false},
    {'id': 3, 'name': 'Robert Johnson', 'present': false},
    {'id': 4, 'name': 'Maria Garcia', 'present': false},
    {'id': 5, 'name': 'David Kim', 'present': false},
    {'id': 6, 'name': 'Lisa Chen', 'present': false},
    {'id': 7, 'name': 'Michael Brown', 'present': false},
    {'id': 8, 'name': 'Sarah Miller', 'present': false},
  ];

  // Filtered students based on search query
  List<Map<String, dynamic>> _filteredStudents = [];
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _filteredStudents = List.from(_students);
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _filterStudents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredStudents = List.from(_students);
      } else {
        _filteredStudents = _students
            .where((student) => 
                student['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  void _toggleAttendance(int studentId, bool value) {
    setState(() {
      // Update in filtered list
      final studentIndex = _filteredStudents.indexWhere((s) => s['id'] == studentId);
      if (studentIndex != -1) {
        _filteredStudents[studentIndex]['present'] = value;
      }
      
      // Update in main list
      final mainStudentIndex = _students.indexWhere((s) => s['id'] == studentId);
      if (mainStudentIndex != -1) {
        _students[mainStudentIndex]['present'] = value;
      }
    });
  }
  
  void _markAllPresent(bool value) {
    setState(() {
      for (var student in _students) {
        student['present'] = value;
      }
      for (var student in _filteredStudents) {
        student['present'] = value;
      }
    });
  }
  
  Future<void> _submitAttendance() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Count present students
        final presentCount = _students.where((s) => s['present']).length;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance marked for $presentCount students'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset form
        setState(() {
          _selectedDate = DateTime.now();
          for (var student in _students) {
            student['present'] = false;
          }
          _filteredStudents = List.from(_students);
          _searchQuery = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Date selection section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '(Only today or past dates)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _filterStudents('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _filterStudents,
                  ),
                ],
              ),
            ),
            
            // Student list header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Students (${_filteredStudents.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _markAllPresent(true),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('All present'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _markAllPresent(false),
                        icon: const Icon(Icons.highlight_off, size: 18),
                        label: const Text('All absent'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Student list
            Expanded(
              child: _filteredStudents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No students found'
                                : 'No students match "$_searchQuery"',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextButton(
                                onPressed: () => _filterStudents(''),
                                child: const Text('Clear search'),
                              ),
                            ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredStudents.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        return CheckboxListTile(
                          title: Text(
                            student['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: student['present'],
                          onChanged: (value) => _toggleAttendance(student['id'], value ?? false),
                          secondary: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Text(
                              student['name'][0],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          activeColor: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
            ),
            
            // Submit button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAttendance,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Saving...'),
                        ],
                      )
                    : const Text('Submit Attendance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 