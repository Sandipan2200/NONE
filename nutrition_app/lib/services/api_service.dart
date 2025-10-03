import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // For Android emulator
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  final SharedPreferences _prefs;

  ApiService(this._prefs);

  String? get authToken => _prefs.getString(_tokenKey);
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _prefs.setString(_tokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode == 401 && refreshToken != null) {
      // Try token refresh
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        // Retry original request
        final newResponse = await _retryRequest(response.request!);
        return _processResponse(newResponse);
      }
    }
    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final data = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  Future<bool> refreshAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/refresh/'),
        body: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await saveTokens(data['access'], refreshToken!);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<http.Response> _retryRequest(http.BaseRequest originalRequest) async {
    final request = http.Request(originalRequest.method, originalRequest.url)
      ..headers.addAll(originalRequest.headers)
      ..body = originalRequest is http.Request ? originalRequest.body : '';

    request.headers['Authorization'] = 'Bearer $authToken';
    return http.Response.fromStream(await request.send());
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // Auth endpoints
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    final data = await _handleResponse(response);
    if (data['tokens'] != null) {
      await saveTokens(data['tokens']['access'], data['tokens']['refresh']);
    }
    return data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    return _handleResponse(response);
  }

  // Profile endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile/'),
      headers: _headers,
      body: json.encode(profileData),
    );
    return _handleResponse(response);
  }

  // Food endpoints
  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/foods/?search=$query'),
      headers: _headers,
    );
    final data = await _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // Tracking endpoints
  Future<Map<String, dynamic>> logFood(Map<String, dynamic> foodLog) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-logs/'),
      headers: _headers,
      body: json.encode(foodLog),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDailyNutritionSummary(String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/nutrition-summary/?date=$date'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCalendarData(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/nutrition-summary/calendar_data/?start_date=$startDate&end_date=$endDate'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // Diet plan endpoints
  Future<Map<String, dynamic>> generateDietPlan() async {
    final response = await http.post(
      Uri.parse('$baseUrl/diet-plans/generate/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}
