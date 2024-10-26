// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      age: fields[0] as int?,
      activityLevel: fields[1] as int?,
      hasWeightGoals: fields[2] as bool,
      vegan: fields[3] as bool,
      vegetarian: fields[4] as bool,
      glutenIntolerant: fields[5] as bool,
      currentWeight: fields[6] as int?,
      weightGoal: fields[7] as int?,
      religion: fields[8] as String?,
      chronicConditions: (fields[9] as List?)?.cast<String>(),
      nutrientDeciencies: (fields[10] as List?)?.cast<String>(),
      restrictions: (fields[11] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.activityLevel)
      ..writeByte(2)
      ..write(obj.hasWeightGoals)
      ..writeByte(3)
      ..write(obj.vegan)
      ..writeByte(4)
      ..write(obj.vegetarian)
      ..writeByte(5)
      ..write(obj.glutenIntolerant)
      ..writeByte(6)
      ..write(obj.currentWeight)
      ..writeByte(7)
      ..write(obj.weightGoal)
      ..writeByte(8)
      ..write(obj.religion)
      ..writeByte(9)
      ..write(obj.chronicConditions)
      ..writeByte(10)
      ..write(obj.nutrientDeciencies)
      ..writeByte(11)
      ..write(obj.restrictions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
