class StationSensor {
  int? sensorId;
  String? name;

  StationSensor({this.sensorId, this.name});

  StationSensor.fromJson(Map<String, dynamic> json) {
    sensorId = json['sensor_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensor_id'] = sensorId;
    data['name'] = name;
    return data;
  }
}
