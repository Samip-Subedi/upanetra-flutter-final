
import '../../../data/model/product_model.dart';

abstract class ShoppingEvent {}

class FetchProducts extends ShoppingEvent {}

class AddProductToCart extends ShoppingEvent {
  final Product product;
  AddProductToCart(this.product);
}
class RemoveCart extends ShoppingEvent {
  final Product product;
  RemoveCart(this.product);
}

class AddToFavorites extends ShoppingEvent {
  final Product product;
  AddToFavorites(this.product);
}

class RemoveFromFavorites extends ShoppingEvent {
  final Product product;
  RemoveFromFavorites(this.product);
}

class FetchOrders extends ShoppingEvent {}
class SearchProducts extends ShoppingEvent { // New event
  final String query;
  SearchProducts(this.query);
}