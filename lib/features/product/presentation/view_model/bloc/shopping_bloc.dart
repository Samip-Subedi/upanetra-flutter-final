import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_app/features/add%20to%20cart%20and%20order/domain/use_case/remove_from_cart.dart';

import '../../../data/model/product_model.dart';
import '../../../../auth/data/model/user_hive_model.dart';
import '../../../../../app/constant/api_config.dart';
import '../../../../add to cart and order/domain/use_case/add_to_cart.dart';
import '../../../domain/use_case/get_products_usecase.dart';
import '../../../../auth/domain/use_case/usercase.dart';
import 'shopping_event.dart';
import 'shopping_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer; // For logging

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  final GetProducts getProducts; // Use case to fetch products
  final AddToCart addToCart;     // Use case to add to cart
  List<Product> cart = [];       // Local cart state
RemoveFromCart removeFromCart;
  ShoppingBloc(this.getProducts, this.addToCart,this.removeFromCart) : super(ShoppingInitial()) {
    // Fetch Products Event
    on<FetchProducts>((event, emit) async {
      emit(ShoppingLoading());
      try {
        final products = await getProducts(NoParams());
        developer.log('Products fetched: ${products.length} items');
        emit(ShoppingLoaded(products, cart));
      } catch (e) {
        developer.log('Error fetching products: $e');
        emit(ShoppingError('Failed to load products: $e.toString()'));
      }
    });

    // Add Product to Cart Event
   on<AddProductToCart>((event, emit) async {
      try {
        await addToCart(event.product);
        cart.add(event.product);
        developer.log('Bloc: Product added to cart: ${event.product.name}');
        
        if (state is ShoppingLoaded) {
          emit(ShoppingLoaded((state as ShoppingLoaded).products, cart));
        } else {
          emit(ShoppingLoaded([], cart));
        }
      } catch (e) {
        developer.log('Bloc: Error adding to cart: $e');
        emit(ShoppingError('Failed to add product to cart: $e.toString()'));
      }
    });
   on<FetchOrders>((event, emit) async {
      emit(ShoppingLoading());
      try {
        final authBox = Hive.box<UserHiveModel>('authBox');
        final token = authBox.get('currentUser')?.token;

        if (token == null) {
          throw Exception('Please log in to view orders');
        }

        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/orders/me'),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'token=$token',
          },
        );

        developer.log('Orders Response: ${response.statusCode} - ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final orders = data['orders'] ?? [];
          if (state is ShoppingLoaded) {
            emit(ShoppingLoaded((state as ShoppingLoaded).products, cart, orders: orders));
          } else {
            emit(ShoppingLoaded([], cart, orders: orders));
          }
        } else {
          throw Exception('Failed to fetch orders: ${response.statusCode}');
        }
      } catch (e) {
        developer.log('Bloc: Error fetching orders: $e');
        emit(ShoppingError('Failed to load orders: $e.toString()'));
      }
    });
    on<RemoveCart>((event, emit) async {
      try {
        await removeFromCart(event.product);
        cart.removeWhere((item) => item.id == event.product.id);
        developer.log('Bloc: Product removed from cart: ${event.product.name}');
        if (state is ShoppingLoaded) {
          emit(ShoppingLoaded((state as ShoppingLoaded).products, cart));
        } else {
          emit(ShoppingLoaded([], cart));
        }
      } catch (e) {
        developer.log('Bloc: Error removing from cart: $e');
        emit(ShoppingError('Failed to remove product from cart: $e.toString()'));
      }
    });
    on<AddToFavorites>((event, emit) async {
  final favoriteBox = Hive.box<ProductModel>('favoriteBox');
  if (!favoriteBox.values.any((item) => item.id == event.product.id)) {
    favoriteBox.add(event.product as ProductModel);
  }
  emit(ShoppingLoaded((state as ShoppingLoaded).products, cart));
});
on<SearchProducts>((event, emit) async {
      if (state is ShoppingLoaded) {
        final allProducts = (state as ShoppingLoaded).products;
        final query = event.query.toLowerCase();
        final searchResults = allProducts.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query);
        }).toList();
        emit(ShoppingLoaded(
          allProducts,
          cart,
          orders: (state as ShoppingLoaded).orders,
          searchResults: searchResults,
        ));
      } else {
        // If products aren't loaded yet, fetch them first
        emit(ShoppingLoading());
        try {
          final products = await getProducts(NoParams());
          final query = event.query.toLowerCase();
          final searchResults = products.where((product) {
            return product.name.toLowerCase().contains(query) ||
                product.description.toLowerCase().contains(query);
          }).toList();
          emit(ShoppingLoaded(products, cart, searchResults: searchResults));
        } catch (e) {
          emit(ShoppingError('Failed to load products for search: $e.toString()'));
        }
      }
    });

on<RemoveFromFavorites>((event, emit) async {
  final favoriteBox = Hive.box<ProductModel>('favoriteBox');
  final index = favoriteBox.values.toList().indexWhere((item) => item.id == event.product.id);
  if (index != -1) favoriteBox.deleteAt(index);
  emit(ShoppingLoaded((state as ShoppingLoaded).products, cart));
});
  }
  

  // Load cart from Hive on initialization
  void _loadCartFromHive() async {
    try {
      final cartBox = Hive.box<ProductModel>('cartBox');
      cart = cartBox.values.toList();
      developer.log('Bloc: Loaded ${cart.length} items from cart');
      if (state is ShoppingLoaded) {
        emit(ShoppingLoaded((state as ShoppingLoaded).products, cart));
      }
    } catch (e) {
      developer.log('Bloc: Error loading cart from Hive: $e');
    }
  }
  
}
