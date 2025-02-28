import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../utils/usecase/remove_from_cart.dart';
import '../../../product/presentation/view_model/bloc/shopping_bloc.dart';
import '../../../product/presentation/view_model/bloc/shopping_state.dart';
import 'check_out_viewpage.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocBuilder<ShoppingBloc, ShoppingState>(
        builder: (context, state) {
          if (state is ShoppingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShoppingLoaded) {
            final cartItems = state.cart;
            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            // Calculate total amount
            final totalAmount = cartItems.fold<double>(
              0.0,
              (sum, item) => sum + item.price,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_shopping_cart),
                          onPressed: () {
                            // context
                            //     .read<ShoppingBloc>()
                            //     .add(RemoveFromCart(product));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(totalAmount: totalAmount),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Full width
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Checkout (\$${totalAmount.toStringAsFixed(2)})',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ShoppingError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Cart not loaded'));
        },
      ),
    );
  }
}