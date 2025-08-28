// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostCacheModelAdapter extends TypeAdapter<PostCacheModel> {
  @override
  final int typeId = 2;

  @override
  PostCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostCacheModel(
      id: fields[0] as String,
      authorName: fields[1] as String,
      authorAvatarUrl: fields[2] as String,
      text: fields[3] as String,
      imageUrl: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PostCacheModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.authorAvatarUrl)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
