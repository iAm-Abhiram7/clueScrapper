// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportModelAdapter extends TypeAdapter<ReportModel> {
  @override
  final int typeId = 4;

  @override
  ReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportModel(
      reportId: fields[0] as String,
      chatId: fields[1] as String,
      generatedAt: fields[2] as DateTime,
      summary: fields[3] as String,
      evidenceList: fields[4] as String,
      observations: fields[5] as String,
      crimeType: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReportModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.reportId)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.generatedAt)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.evidenceList)
      ..writeByte(5)
      ..write(obj.observations)
      ..writeByte(6)
      ..write(obj.crimeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
