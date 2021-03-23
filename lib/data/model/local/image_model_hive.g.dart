// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageModeHiveAdapter extends TypeAdapter<ImageModeHive> {
  @override
  final int typeId = 0;

  @override
  ImageModeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageModeHive(
      fields[0] as bool,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageModeHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isFav)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.sourceUrl)
      ..writeByte(4)
      ..write(obj.mediumUrl)
      ..writeByte(5)
      ..write(obj.largeUrl)
      ..writeByte(6)
      ..write(obj.thumbnailUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
