import 'package:latlong2/latlong.dart';

import '../../constants/app_constant.dart';
import '../station/station_model.dart';
import 'package:flutter_map/flutter_map.dart';

import '../sensor/sensor_model.dart';
import '../station/station_record_model.dart';

class MapViewModel {
  MapViewModel._instance();
  bool isDark = false;
  List<Station> stationList = [];
  List<Station> enableStationList = [];
  List<Marker> markerList = [];
  List<Sensor> sensorList = [];
  Map<int, List<StationRecord>> stationRecordMap = {};
  Map<int, double> stationSensorQuality = {};
  Sensor? selectedSensor;
  bool isInit = false;
  LatLng focusLatLng = AppConstant.defaultLatLng;
  bool isEnableRotateSensor = true;
  int rotatingSensorInterval = 10;

  void clear() {
    isInit = false;
    stationList.clear();
    markerList.clear();
    sensorList.clear();
    stationSensorQuality.clear();
    stationRecordMap.clear();
  }

  static MapViewModel instance = MapViewModel._instance();

  factory MapViewModel() {
    return instance;
  }
}
