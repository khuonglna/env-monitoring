import 'package:latlong2/latlong.dart';

import '../sensor/sensor_model.dart';
import 'station_record_model.dart';

class Station {
  int? stationId;
  String? name;
  String? address;
  LatLng? latLng;
  List<Sensor>? sensors;
  List<StationRecord>? stationRecords = [];
  Station({
    this.stationId,
    this.name,
    this.address,
    this.latLng,
    this.sensors,
    this.stationRecords = const [],
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
      sensors = <Sensor>[];
      json['sensors'].forEach(
        (v) {
          sensors!.add(Sensor.fromJson(v));
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
      data['sensors'] = sensors
          ?.map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}
