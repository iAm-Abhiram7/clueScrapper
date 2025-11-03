// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvidenceModelAdapter extends TypeAdapter<EvidenceModel> {
  @override
  final int typeId = 3;

  @override
  EvidenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvidenceModel(
      evidenceId: fields[0] as String,
      type: fields[1] as String,
      description: fields[2] as String,
      confidence: fields[3] as double,
      imageReference: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EvidenceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.evidenceId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.imageReference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvidenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
