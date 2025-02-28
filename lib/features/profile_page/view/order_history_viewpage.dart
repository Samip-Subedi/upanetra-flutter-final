import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product/presentation/view_model/bloc/shopping_bloc.dart';
import '../../product/presentation/view_model/bloc/shopping_event.dart';
import '../../product/presentation/view_model/bloc/shopping_state.dart';


class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
              context.read<ShoppingBloc>().add(FetchOrders());

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ShoppingBloc>().add(FetchOrders());
            },
          ),
        ],
      ),
      body: BlocConsumer<ShoppingBloc, ShoppingState>(
        listener: (context, state) {
          if (state is ShoppingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ShoppingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ShoppingLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return Center(child: Text('No orders yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['_id']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Items: ${order['orderItems']?.length ?? 0}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Status: ${order['paymentInfo']?['status'] ?? 'Pending'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Date: ${order['createdAt']?.substring(0, 10) ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Shipping: ${order['shippingInfo']?['address'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ShoppingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.read<ShoppingBloc>().add(FetchOrders()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          // Initial state: trigger fetch
          context.read<ShoppingBloc>().add(FetchOrders());
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}