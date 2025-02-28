

import 'package:hive_flutter/hive_flutter.dart';

import '../../data_source/remote_datasource/shopping_remote_datasource.dart';
import '../../model/product_model.dart';
import '../shopping_repository.dart';
import 'dart:developer' as developer;
class ShoppingRepositoryImpl implements ShoppingRepository {
  final ShoppingRemoteDataSource remoteDataSource;
final Box<ProductModel> cartBox = Hive.box<ProductModel>('cartBox');
  ShoppingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await remoteDataSource.getProducts();
    return productModels; // Models extend Product, so this is fine
  }

 @override
  Future<void> addToCart(Product product) async {
    try {
      ProductModel productModel;
      if (product is ProductModel) {
        productModel = product;
      } else {
        productModel = ProductModel(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
          offerPrice: product.offerPrice,
          ratings: 0,
          images: [
            ImageModel(
              publicId: 'default',
              url: product.imageUrl,
              id: 'default',
            )
          ],
          category: 'Uncategorized',
          stock: 1,
          noOfReviews: 0,
          user: 'unknown',
          createdAt: DateTime.now().toIso8601String(),
          reviews: [],
          version: 0,
        );
      }
      await cartBox.add(productModel);
      developer.log('Repository: Added ${productModel.name} to cart in Hive');
    } catch (e) {
      developer.log('Repository: Error adding to cart: $e');
      rethrow;
    }
  }

  @override
  Future<List<Product>> getCartItems() async {
    try {
      final cartItems = cartBox.values.toList();
      developer.log('Repository: Retrieved ${cartItems.length} cart items');
      return cartItems;
    } catch (e) {
      developer.log('Repository: Error fetching cart items: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(Product product) async {
    try {
      final index = cartBox.values
          .toList()
          .indexWhere((item) => item.id == product.id);
      if (index != -1) {
        await cartBox.deleteAt(index);
        developer.log('Repository: Removed ${product.name} from cart in Hive');
      } else {
        developer.log('Repository: Product ${product.name} not found in cart');
      }
    } catch (e) {
      developer.log('Repository: Error removing from cart: $e');
      rethrow;
    }
  }
}