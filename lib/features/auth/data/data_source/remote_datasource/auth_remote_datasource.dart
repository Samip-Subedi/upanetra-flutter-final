import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/features/auth/data/model/user_hive_model.dart';
import 'package:shopping_app/app/constant/api_config.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

 Future<UserHiveModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse(ApiConfig.login),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    // Log the status code and response body for debugging
   log('Login Status Code: ${response.statusCode}');
  log('Login Response Body: ${response.body}');

    if (response.statusCode == 201) { // Change 201 to 200
      final userHiveModel = UserHiveModel.fromJson(json.decode(response.body));
      
      // Store in Hive
      final box = Hive.box<UserHiveModel>('authBox');
      await box.put('currentUser', userHiveModel);
      
     log('User stored in Hive: ${userHiveModel.user.email}');
      return userHiveModel;
    } else {
      throw Exception('Login failed with status code: ${response.statusCode}');
    }
  }

  Future<void> register(String email, String password,String name) async {  // Change to Future<void>
    final response = await client.post(
      Uri.parse(ApiConfig.register),
      body: json.encode({'name':name, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    log("message ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] != true) {
        throw Exception('Registration failed');
      }
      // No user data to store, just return success
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }
}