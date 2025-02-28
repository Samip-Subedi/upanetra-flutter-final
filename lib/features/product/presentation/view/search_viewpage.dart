import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../view_model/bloc/shopping_bloc.dart';
import '../view_model/bloc/shopping_event.dart';
import '../view_model/bloc/shopping_state.dart';
import '../../../../app/widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or description',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    context.read<ShoppingBloc>().add(SearchProducts(_searchController.text));
                  },
                ),
              ),
              onSubmitted: (value) {
                context.read<ShoppingBloc>().add(SearchProducts(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                if (state is ShoppingLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ShoppingLoaded) {
                  final searchResults = state.searchResults;
                  if (searchResults.isEmpty && _searchController.text.isNotEmpty) {
                    return Center(child: Text('No products found'));
                  }
                  return ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: searchResults[index],
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${searchResults[index].name} added to cart')),
                          );
                        },
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
                          onPressed: () => context.read<ShoppingBloc>().add(FetchProducts()),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text('Start typing to search'));
              },
            ),
          ),
        ],
      ),
    );
  }
}