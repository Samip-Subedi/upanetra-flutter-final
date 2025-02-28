import 'package:hive/hive.dart';
part 'user_hive_model.g.dart'; // Ensure this matches the file name
@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final bool success;

  @HiveField(1)
  final UserData user;

  @HiveField(2)
  final String token;

  UserHiveModel({
    required this.success,
    required this.user,
    required this.token,
  });

  factory UserHiveModel.fromJson(Map<String, dynamic> json) {
    return UserHiveModel(
      success: json['success'] as bool,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

@HiveType(typeId: 1)
class UserData extends HiveObject {
  @HiveField(0)
  final Avatar avatar;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final String role;

  @HiveField(6)
  final String createdAt;

  UserData({
    required this.avatar,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

@HiveType(typeId: 2)
class Avatar extends HiveObject {
  @HiveField(0)
  final String publicId;

  @HiveField(1)
  final String url;

  Avatar({
    required this.publicId,
    required this.url,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      publicId: json['public_id'] as String,
      url: json['url'] as String,
    );
  }
}