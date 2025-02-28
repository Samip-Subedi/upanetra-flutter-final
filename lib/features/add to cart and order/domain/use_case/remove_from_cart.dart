
import 'dart:developer' as developer;

import '../../../product/data/model/product_model.dart';
import '../../../product/data/repository/shopping_repository.dart';
import '../../../auth/domain/use_case/usercase.dart';

class RemoveFromCart implements UseCase<void, Product> {
  final ShoppingRepository repository;

  RemoveFromCart(this.repository);

  @override
  Future<void> call(Product product) async {
    try {
      await repository.removeFromCart(product);
      developer.log('UseCase: Removed ${product.name} from cart');
    } catch (e) {
      developer.log('UseCase: RemoveFromCart failed: $e');
      rethrow;
    }
  }
}