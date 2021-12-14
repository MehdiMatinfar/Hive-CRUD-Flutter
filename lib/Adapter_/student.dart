import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Student {
  @HiveField(0)
  late int _sid;
  @HiveField(1)
  late String _name;
  @HiveField(2)
  late String _field;


  Student(this._sid, this._name, this._field );


  String get field => _field;

  set field(String value) {
    _field = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get sid => _sid;

  set sid(int value) {
    _sid = value;
  }
}

class StudentAdapter extends TypeAdapter<Student> {
  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{

      for (int i = 0; i < numOfFields; i++)


        reader.readByte(): reader.read(),
    };
    return Student(
        fields[0] as int,
        fields[1] as String,
        fields[2] as String,
    );
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Student obj) {

    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._sid)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._field)
     ;

  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
