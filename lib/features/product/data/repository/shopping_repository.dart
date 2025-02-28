
import '../model/product_model.dart';

abstract class ShoppingRepository {
  /// Fetches a list of products from the data source.
  Future<List<Product>> getProducts();

  /// Adds a product to the cart.
  Future<void> addToCart(Product product);
  Future<List<Product>> getCartItems();
  Future<void> removeFromCart(Product product);
}