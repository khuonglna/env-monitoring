class Record {
  int? sensorId;
  String? sensorName;
  double? value;

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
}
