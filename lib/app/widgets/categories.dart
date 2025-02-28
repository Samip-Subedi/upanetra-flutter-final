import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
     final List<String> categories = [
    "Men glasses",
    "Women glasses",
    "Kids glasses",
    "Polarized glasses",
    "Blue light glasses",
    "Reading glasses",
  ];
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
            SizedBox(height: 16.0),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 16.0,
                
                mainAxisSpacing: 16.0,
                childAspectRatio: 3, // Adjust item aspect ratio
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: categories[index]);
              },
            ),
          ],
        ),
      );
    
  }
}


class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}