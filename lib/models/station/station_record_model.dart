import 'record.dart';

class StationRecord {
  int? recordId;
  int? secondTillEpoch;
  List<Record>? records;

  StationRecord({
    this.recordId,
    this.records,
    this.secondTillEpoch,
  });

  StationRecord.fromJson(Map<String, dynamic> json) {
    recordId = json['record_id'];
    secondTillEpoch = json['time'];
    if (json['sensor_value'] != null) {
      records = <Record>[];
      json['sensor_value'].forEach(
        (v) {
          records!.add(
            Record.fromJson(v),
          );
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['record_id'] = recordId;
    data['time'] = secondTillEpoch;
    data['sensor_value'] = records!
        .map(
          (e) => e.toJson(),
        )
        .toList();
    return data;
  }
}
