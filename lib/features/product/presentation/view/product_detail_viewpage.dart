import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';


import '../../data/model/product_model.dart';
import '../../data/model/review_model.dart';
import '../../../auth/data/model/user_hive_model.dart';
import '../../../../app/widgets/review_widget.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the product is already in favorites
    final favoriteBox = Hive.box<ProductModel>('favoriteBox');
    _isFavorite = favoriteBox.values.any((item) => item.id == widget.product.id);
  }

  void _toggleFavorite() {
    final favoriteBox = Hive.box<ProductModel>('favoriteBox');
    setState(() {
      if (_isFavorite) {
        final index = favoriteBox.values
            .toList()
            .indexWhere((item) => item.id == widget.product.id);
        favoriteBox.deleteAt(index);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.product.name} removed from favorites')),
        );
      } else {
        favoriteBox.add(widget.product);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.product.name} added to favorites')),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box<UserHiveModel>('authBox');
    final user = authBox.get('currentUser')?.user;
    final reviewBox = Hive.box<ReviewModel>('reviewBox');
    final reviews = reviewBox.values
        .where((review) => review.productId == widget.product.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(
                      widget.product.images[index].url,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Product Details
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              'Offer Price: \$${widget.product.offerPrice}',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text('Category: ${widget.product.category}'),
            Text('Stock: ${widget.product.stock}'),
            SizedBox(height: 16),
            // Rating and Comment Section
            Text(
              'Rate this product:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please log in to add a review')),
                  );
                  return;
                }
                if (_rating == 0.0 || _commentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a rating and comment')),
                  );
                  return;
                }
                final review = ReviewModel(
                  productId: widget.product.id,
                  userId: user.id,
                  rating: _rating.toInt(),
                  comment: _commentController.text,
                  createdAt: DateTime.now(),
                );
                reviewBox.add(review);
                setState(() {
                  _rating = 0.0;
                  _commentController.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review added successfully')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Submit Review'),
              ),
            ),
            SizedBox(height: 16),
            // Reviews List
            Text(
              'Reviews (${reviews.length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            reviews.isEmpty
                ? Text('No reviews yet.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ReviewWidget(review: reviews[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}