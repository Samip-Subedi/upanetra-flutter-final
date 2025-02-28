// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 3;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      imageUrl: fields[3] as String,
      description: fields[4] as String,
      offerPrice: fields[5] as String,
      ratings: fields[6] as int,
      images: (fields[7] as List).cast<ImageModel>(),
      category: fields[8] as String,
      stock: fields[9] as int,
      noOfReviews: fields[10] as int,
      user: fields[11] as String,
      createdAt: fields[12] as String,
      reviews: (fields[13] as List).cast<dynamic>(),
      version: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.offerPrice)
      ..writeByte(6)
      ..write(obj.ratings)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.stock)
      ..writeByte(10)
      ..write(obj.noOfReviews)
      ..writeByte(11)
      ..write(obj.user)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.reviews)
      ..writeByte(14)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageModelAdapter extends TypeAdapter<ImageModel> {
  @override
  final int typeId = 4;

  @override
  ImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageModel(
      publicId: fields[0] as String,
      url: fields[1] as String,
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.publicId)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
