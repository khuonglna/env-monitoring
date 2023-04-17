import '../sensor/sensor_model.dart';
import 'record_model.dart';

class StationRecord {
  int? recordId;
  int? secondSinceEpoch;
  List<Record>? records;
  double? stationSQI;

  StationRecord({
    this.recordId,
    this.records,
    this.secondSinceEpoch,
  });

  StationRecord.fromJson(Map<String, dynamic> json) {
    recordId = json['record_id'];
    secondSinceEpoch = json['time'];
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
    data['time'] = secondSinceEpoch;
    data['sensor_value'] = records
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    return data;
  }

  void calculateStationSQI(List<Sensor> sensorList) {
    double sum = 0;
    for (final record in (records ?? <Record>[])) {
      for (final sensor in sensorList) {
        if (record.sensorId == sensor.sensorId) {
          final average = (sensor.upperBound! + sensor.lowerBound!) / 2;
          if (record.value != null) {
            sum += (record.value! - average).abs() * sensor.differBound!;
          }
        }
      }
    }
    stationSQI = sum;
  }
}
