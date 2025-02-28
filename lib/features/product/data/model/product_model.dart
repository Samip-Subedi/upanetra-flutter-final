import 'package:hive/hive.dart';
part 'product_model.g.dart'; // Must match the file name

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // Primary image URL
  final String description;
  final String offerPrice;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.offerPrice,
  });
}

@HiveType(typeId: 3)
class ProductModel extends Product {
  @HiveField(0)
  final String id; // Add inherited fields with annotations

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String offerPrice;

  @HiveField(6)
  final int ratings;

  @HiveField(7)
  final List<ImageModel> images;

  @HiveField(8)
  final String category;

  @HiveField(9)
  final int stock;

  @HiveField(10)
  final int noOfReviews;

  @HiveField(11)
  final String user;

  @HiveField(12)
  final String createdAt;

  @HiveField(13)
  final List<dynamic> reviews;

  @HiveField(14)
  final int version;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.offerPrice,
    required this.ratings,
    required this.images,
    required this.category,
    required this.stock,
    required this.noOfReviews,
    required this.user,
    required this.createdAt,
    required this.reviews,
    required this.version,
  }) : super(
          id: id,
          name: name,
          price: price,
          imageUrl: imageUrl,
          description: description,
          offerPrice: offerPrice,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: (json['images'] as List).isNotEmpty
          ? (json['images'][0]['url'] as String)
          : '',
      description: json['description'] as String,
      offerPrice: json['offerPrice'] as String,
      ratings: json['ratings'] as int,
      images: (json['images'] as List)
          .map((image) => ImageModel.fromJson(image as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String,
      stock: json['stock'] as int,
      noOfReviews: json['NoOfReviews'] as int,
      user: json['user'] as String,
      createdAt: json['createdAt'] as String,
      reviews: json['reviews'] as List<dynamic>,
      version: json['__v'] as int,
    );
  }
}

@HiveType(typeId: 4)
class ImageModel {
  @HiveField(0)
  final String publicId;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String id;

  ImageModel({
    required this.publicId,
    required this.url,
    required this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      publicId: json['public_id'] as String,
      url: json['url'] as String,
      id: json['_id'] as String,
    );
  }
}