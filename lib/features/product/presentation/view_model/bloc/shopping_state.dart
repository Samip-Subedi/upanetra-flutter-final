
import 'package:shopping_app/features/product/data/model/product_model.dart';

abstract class ShoppingState {}

class ShoppingInitial extends ShoppingState {} // Initial state

class ShoppingLoading extends ShoppingState {} // Loading products

class ShoppingLoaded extends ShoppingState {
  final List<Product> products; // List of products from API
  final List<Product> cart;     // Cart items
final List<dynamic> orders;
final List<Product> searchResults;
  ShoppingLoaded(this.products, this.cart,{this.orders = const [],this.searchResults = const [],});
}

class ShoppingError extends ShoppingState {
  final String message; // Error message
  ShoppingError(this.message);
}

