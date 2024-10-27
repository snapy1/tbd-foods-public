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
      currentWeight: fields[3] as int?,
      weightGoal: fields[4] as int?,
      religion: fields[5] as String?,
      chronicConditions: (fields[6] as List?)?.cast<String>(),
      nutrientDeficiencies: (fields[7] as List?)?.cast<String>(),
      restrictions: (fields[8] as List?)?.cast<String>(),
      debugMode: fields[9] as bool,
      miscInformation: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.activityLevel)
      ..writeByte(2)
      ..write(obj.hasWeightGoals)
      ..writeByte(3)
      ..write(obj.currentWeight)
      ..writeByte(4)
      ..write(obj.weightGoal)
      ..writeByte(5)
      ..write(obj.religion)
      ..writeByte(6)
      ..write(obj.chronicConditions)
      ..writeByte(7)
      ..write(obj.nutrientDeficiencies)
      ..writeByte(8)
      ..write(obj.restrictions)
      ..writeByte(9)
      ..write(obj.debugMode)
      ..writeByte(10)
      ..write(obj.miscInformation);
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
