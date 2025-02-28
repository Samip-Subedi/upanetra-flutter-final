import 'package:hive/hive.dart';
part 'review_model.g.dart';

@HiveType(typeId: 5)
class ReviewModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final int rating;

  @HiveField(3)
  final String comment;

  @HiveField(4)
  final DateTime createdAt;

  ReviewModel({
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}