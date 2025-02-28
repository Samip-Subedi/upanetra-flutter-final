import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app/features/product/presentation/view_model/bloc/shopping_bloc.dart';


import '../../product/data/model/product_model.dart';
import '../../product/presentation/view_model/bloc/shopping_event.dart';
import '../../product/presentation/view/product_detail_viewpage.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteBox = Hive.box<ProductModel>('favoriteBox');
    final favorites = favoriteBox.values.toList();

    return Scaffold(
      
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? Center(child: Text('No favorite items yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          context.read<ShoppingBloc>().add(AddProductToCart(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} added to cart')),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          final index = favoriteBox.values
                              .toList()
                              .indexWhere((item) => item.id == product.id);
                          favoriteBox.deleteAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} removed from favorites')),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}