import 'package:latlong2/latlong.dart';

import '../sensor/station_sensor_model.dart';

class Station {
  int? stationId;
  String? name;
  String? address;
  LatLng? latLng;
  List<StationSensor>? sensors;
  Station({
    this.stationId,
    this.name,
    this.address,
    this.latLng,
    this.sensors,
  });

  Station.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    name = json['name'];
    address = json['address'];
    latLng = LatLng(
      double.parse(json['latitude']),
      double.parse(
        json['longitude'],
      ),
    );
    if (json['sensors'] != null) {
      sensors = <StationSensor>[];
      json['sensors'].forEach(
        (v) {
          sensors!.add(StationSensor.fromJson(v));
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['station_id'] = stationId;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latLng?.latitude;
    data['longitude'] = latLng?.longitude;
    if (sensors != null) {
      data['sensors'] = sensors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
