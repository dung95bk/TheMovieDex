// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_item_list_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieItemListHiveAdapter extends TypeAdapter<MovieItemListHive> {
  @override
  final int typeId = 7;

  @override
  MovieItemListHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieItemListHive(
      fields[10] as int,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
      fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovieItemListHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.title)
      ..writeByte(12)
      ..write(obj.date)
      ..writeByte(13)
      ..write(obj.posterPath)
      ..writeByte(14)
      ..write(obj.isTvShow);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieItemListHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
