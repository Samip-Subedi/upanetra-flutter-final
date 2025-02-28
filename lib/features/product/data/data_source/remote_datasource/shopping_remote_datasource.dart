import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/product_model.dart';
import '../../../../../app/constant/api_config.dart';


class ShoppingRemoteDataSource {
  final http.Client client;

  ShoppingRemoteDataSource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse(ApiConfig.products));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)["products"];
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}