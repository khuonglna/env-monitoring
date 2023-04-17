import 'sensor_record_model.dart';

class Sensor {
  int? sensorId;
  String? name;
  double? upperBound;
  double? lowerBound;
  double? differBound;
  String? unitSymbol;
  bool? isActive;

  Sensor({
    this.sensorId,
    this.name,
    this.upperBound,
    this.lowerBound,
    this.differBound,
    this.unitSymbol,
    this.isActive,
  });

  Sensor.fromJson(Map<String, dynamic> json) {
    sensorId = json['sensor_id'];
    name = json['name'];
    upperBound = json['upper_bound'];
    lowerBound = json['lower_bound'];
    differBound = json['differ_bound'];
    unitSymbol = json['unit_symbol'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensor_id'] = sensorId;
    data['name'] = name;
    data['upper_bound'] = upperBound;
    data['lower_bound'] = lowerBound;
    data['differ_bound'] = differBound;
    data['unit_symbol'] = unitSymbol;
    data['is_active'] = isActive;
    return data;
  }
}
