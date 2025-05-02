// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labs_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabsTestAdapter extends TypeAdapter<LabsTest> {
  @override
  final int typeId = 1;

  @override
  LabsTest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabsTest(
      testName: fields[0] as String,
      address: fields[2] as String,
      lab: fields[1] as String,
      price: fields[3] as int,
      labId: fields[4] as String?,
      testId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LabsTest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.testName)
      ..writeByte(1)
      ..write(obj.lab)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.labId)
      ..writeByte(5)
      ..write(obj.testId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabsTestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
