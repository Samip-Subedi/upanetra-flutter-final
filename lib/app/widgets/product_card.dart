import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../features/product/data/model/product_model.dart';
import '../../features/product/presentation/view/product_detail_viewpage.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;

  ProductCard({required this.product, required this.onAddToCart});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = _checkFavorite();
  }

  bool _checkFavorite() {
    final favoriteBox = Hive.box<ProductModel>('favoriteBox');
    return favoriteBox.values.any((item) => item.id == widget.product.id);
  }

  void _toggleFavorite() {
    final favoriteBox = Hive.box<ProductModel>('favoriteBox');
    setState(() {
      if (_isFavorite) {
        final index = favoriteBox.values.toList().indexWhere((item) => item.id == widget.product.id);
        favoriteBox.deleteAt(index);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.product.name} removed from favorites')),
        );
      } else {
        favoriteBox.add(widget.product as ProductModel);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.product.name} added to favorites')),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product as ProductModel),
          ),
        );
      },
      child: Card(
        elevation: 5, // Adds shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image with Rounded Corners
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
      
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
      
                    // Price Row
                    Row(
                      children: [
                        // Offer Price (If available)
                        if (widget.product.offerPrice.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '\$${widget.product.offerPrice}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
      
                        // Original Price (Strikethrough if offer is there)
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.product.offerPrice.isNotEmpty
                                ? Colors.grey
                                : Colors.green,
                            decoration: widget.product.offerPrice.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      
              // Wishlist & Add to Cart Buttons
              Column(
                children: [
                 IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : null,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onPressed: widget.onAddToCart,
                    child: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}