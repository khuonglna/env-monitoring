import '../sensor/sensor_model.dart';

class Record {
  int? sensorId;
  String? sensorName;
  double? value;
  double? recordSQI;

  Record({
    this.sensorId,
    this.sensorName,
    this.value,
  });

  Record.fromJson(Map<String, dynamic> json) {
    sensorId = json['sensor_id'];
    sensorName = json['sensor_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sensor_id'] = sensorId;
    data['sensor_name'] = sensorName;
    data['value'] = value;
    return data;
  }

  double calculateRecordSQI(Sensor sensor) {
    final average = (sensor.upperBound! + sensor.lowerBound!) / 2;

    if (value == null) {
      return 0;
    }

    return (value! - average).abs() * sensor.differBound!;
  }
}
