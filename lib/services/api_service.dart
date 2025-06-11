import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://www.zenkarateschoolofindia.com/zen-app/api';
  // static const String baseUrl = 'http://localhost/zen-app/api';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    // Add detailed logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (object) {
        // Custom log format for better readability
        final timestamp = DateTime.now().toIso8601String();
        print('[$timestamp] 🌐 $object');
      },
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get session ID from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final sessionId = prefs.getString('session_id');
        if (sessionId != null) {
          options.headers['Authorization'] = 'Bearer $sessionId';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Log detailed error information
        print('🔴 ERROR DETAILS:');
        print('  Type: ${e.type}');
        print('  Message: ${e.message}');
        print('  Path: ${e.requestOptions.path}');
        print('  Response: ${e.response?.data}');
        print('  Status Code: ${e.response?.statusCode}');
        
        // Handle authentication errors
        if (e.response?.statusCode == 401) {
          _handleAuthError();
        }
        return handler.next(e);
      },
    ));
  }

  // Handle authentication errors
  void _handleAuthError() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Note: Can't navigate here since we don't have context
    // The UI layer should handle navigation when receiving 401 errors
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login.php', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);
        if (responseData['success'] == true) {
          // Save session data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_id', responseData['data']['session_id']);
          await prefs.setString('user_id', responseData['data']['user_id']);
          await prefs.setString('full_name', responseData['data']['full_name']);
          await prefs.setBool('isAdmin', responseData['data']['is_admin'] == 1);
          await prefs.setBool('isLoggedIn', true);
        }
        return responseData;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register.php', data: {
        'full_name': fullName,
        'email': email,
        'mobile': mobile,
        'password': password,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/auth/change-password.php', data: {
        'session_id': sessionId,
        'current_password': currentPassword,
        'new_password': newPassword,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/auth/logout.php', data: {
        'session_id': sessionId,
      });

      // Clear local storage regardless of API response
      await prefs.clear();

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      // Clear local storage even if API call fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> getTeamMembers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/teams/get-team-members.php', data: {
        'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> getWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/workout/get-workouts.php', data: {
        'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> getEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/events/get-events.php', data: {
        'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> getCentres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/center/get-centers.php', data: {
        'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return (response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> submitQuery({
    required String fullName,
    required String email,
    required String phone,
    required String message,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/queries/submit-query.php', data: {
        'session_id': sessionId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'message': message,
      });

      if (response.statusCode == 200) {
        return (response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/auth/get-profile.php', data: {
        'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required int gender,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required int stateId,
    required int countryId,
    required int pincode,
    required String dateOfBirth,
    required String passportNumber,
    required String bloodGroup,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('session_id');
      
      final response = await _dio.post('/auth/update-profile.php', data: {
        'session_id': sessionId,
        'full_name': fullName,
        'gender': gender,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'state_id': stateId,
        'country_id': countryId,
        'pincode': pincode,
        'date_of_birth': dateOfBirth,
        'passport_number': passportNumber,
        'blood_group': bloodGroup,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Invalid response from server',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'error': 'Connection timeout. Please try again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data?['error'] ?? 'Something went wrong. Please try again.',
      };
    }
  }
} 