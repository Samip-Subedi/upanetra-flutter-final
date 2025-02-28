import 'package:flutter/material.dart';

import '../../features/product/data/model/review_model.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;

  ReviewWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Rating: ${review.rating}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
            SizedBox(height: 4),
            Text(review.comment),
            SizedBox(height: 4),
            Text(
              'Posted on: ${review.createdAt.toString().substring(0, 10)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}