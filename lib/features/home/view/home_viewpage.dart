import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product/presentation/view_model/bloc/shopping_bloc.dart';
import '../../product/presentation/view_model/bloc/shopping_event.dart';
import '../../product/presentation/view_model/bloc/shopping_state.dart';
import '../../../app/widgets/categories.dart';
import '../../../app/widgets/product_card.dart';
import '../../../app/widgets/slider_widget.dart';
import '../../add to cart and order/presentation/view/cart_viewpage.dart';
import '../../favourite/view/favourite_viewpage.dart';
import '../../profile_page/view/profile_viewpage.dart';
import '../../product/presentation/view/search_viewpage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(), // Home content with slider and products
    CartPage(),
    FavouritePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch products when the page loads
    context.read<ShoppingBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ShoppingBloc>().add(FetchProducts());

    return Scaffold(
      appBar: AppBar(title: Text('Upanetra'),actions: [
        IconButton(onPressed: (){
          Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
              );
        }, icon: Icon(Icons.search))
      ],),
      body:  SingleChildScrollView(
        child: Column(
        children: [
          // Dummy Slider
          SliderWidget(),
          Categories(),
          // Product List
          BlocBuilder<ShoppingBloc, ShoppingState>(
            builder: (context, state) {
              if (state is ShoppingLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ShoppingLoaded) {
                return ListView.builder(
                  itemCount: state.products.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: state.products[index],
                      onAddToCart: () {
                        context
                            .read<ShoppingBloc>()
                            .add(AddProductToCart(state.products[index]));
                              ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product Added Successfully")),
                    );
                      },
                    );
                  },
                );
              } else if (state is ShoppingError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('No products available'));
            },
          ),
        ],
            ),
      ),
    );
  }
}