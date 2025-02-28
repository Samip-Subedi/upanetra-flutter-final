
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.101:5000/api/v2';

  // Authentication endpoints
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';

  // Shopping endpoints
  static const String products = '$baseUrl/products';
}