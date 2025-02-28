

import '../../data/model/product_model.dart';
import '../../data/repository/shopping_repository.dart';
import '../../../auth/domain/use_case/usercase.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ShoppingRepository repository;

  GetProducts(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getProducts();
  }
}