
import 'dart:developer' as developer;

import '../../../product/data/model/product_model.dart';
import '../../../product/data/repository/shopping_repository.dart';
import '../../../auth/domain/use_case/usercase.dart';

class AddToCart implements UseCase<void, Product> {
  final ShoppingRepository repository;

  AddToCart(this.repository);

  @override
  Future<void> call(Product product) async {
    try {
      await repository.addToCart(product);
      developer.log('UseCase: Added ${product.name} to cart');
    } catch (e) {
      developer.log('UseCase: AddToCart failed: $e');
      rethrow; // Propagate the exception to the bloc
    }
  }
}