import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../constants/api.dart';
import '../../constants/app_constant.dart';
import '../../models/sensor/sensor_model.dart';
import '../../models/station/record.dart';
import '../../models/station/station_model.dart';
import '../../models/station/station_record_model.dart';
import '../../models/view/map_view_model.dart';
import '../../service/request_service.dart';
import '../../utils/app_utils.dart';
import '../base_bloc.dart';

class MapBloc extends BaseCubit {
  MapBloc() : super(InitialState());

  final dio = Dio();

  Timer? _refreshDataTimer;
  Timer? _rotateSensorTimer;
  int sensorIdx = 0;

  void clearTimer() {
    _refreshDataTimer?.cancel();
    _rotateSensorTimer?.cancel();
  }

  Future<void> init() async {
    MapViewModel model = MapViewModel.instance;
    model.selectedSensor = model.sensorList[sensorIdx];

    if (model.enableStationList
            .where((element) => (element.name?.contains('SC') ?? false))
            .length ==
        model.enableStationList.length) {
      // SC center point
      model.focusLatLng = AppConstant.stLatLng;
    } else {
      model.focusLatLng =
          (model.enableStationList.last).latLng ?? AppConstant.defaultLatLng;
    }

    emit(
      LoadedState(
        model,
      ),
    );

    _refreshDataTimer = Timer.periodic(
      const Duration(
        seconds: 30,
      ),
      (timer) {
        log('$runtimeType, data refreshed');
        fetchData();
      },
    );

    _rotateSensorTimer = Timer.periodic(
      const Duration(
        seconds: 10,
      ),
      (timer) {
        sensorIdx += 1;
        sensorIdx %= model.sensorList.length;
        model.selectedSensor = model.sensorList[sensorIdx];
        emit(
          LoadedState(
            model,
          ),
        );
      },
    );
  }

  void dispose() {
    _refreshDataTimer?.cancel();
  }

  Future<void> fetchData() async {
    String errorMessage = '';
    MapViewModel model = MapViewModel.instance;
    if (model.isInit) {
      return emit(
        LoadedState(
          model,
        ),
      );
    }
    // emit(
    //   LoadedState(
    //     model,
    //     isShowLoading: true,
    //   ),
    // );

    try {
      // Get sensor list
      final resSensorList = await RequestService.instance.get(
        API.sensorList,
      );

      if ((resSensorList.code ?? 600) < 400) {
        model.sensorList.clear();
        for (final sensor in resSensorList.data as List<dynamic>) {
          model.sensorList.add(Sensor.fromJson(sensor));
        }
      } else {
        errorMessage = resSensorList.message ?? '';
      }

      // Get station list
      final resStationList = await RequestService.instance.get(
        API.stationList,
      );

      if ((resStationList.code ?? 600) < 400) {
        model.stationList.clear();
        for (final resStation in resStationList.data as List<dynamic>) {
          final station = Station.fromJson(resStation);

          // Get station data
          final resListStationData = await RequestService.instance.get(
            API.stationData,
            query: {
              'station_id': station.stationId,
            },
          );

          if ((resListStationData.code ?? 600) < 400) {
            model.stationRecordMap.clear();
            for (final resStationData
                in resListStationData.data as List<dynamic>) {
              final stationRecord = StationRecord.fromJson(resStationData);
              if (!model.stationRecordMap.containsKey(station.stationId)) {
                model.stationRecordMap.addEntries(
                  {
                    (station.stationId ?? 0): <StationRecord>[],
                  }.entries,
                );
              }

              model.stationRecordMap[station.stationId ?? 0]
                  ?.add(stationRecord);
            }
          }

          if (model.stationRecordMap.isNotEmpty) {
            if (model.stationRecordMap[station.stationId] != null) {
              model.stationRecordMap[station.stationId]!.sort(
                (a, b) => b.secondTillEpoch!.compareTo(a.secondTillEpoch!),
              );
            }
          }

          model.stationSensorQuality.addAll(
            {station.stationId ?? 0: 0},
          );

          station.sensors?.forEach(
            (stationSensor) {
              final sensorData = model.sensorList.singleWhere(
                (s) => s.sensorId == stationSensor.sensorId,
              );

              model.stationSensorQuality[station.stationId ?? 0] =
                  model.stationSensorQuality[station.stationId ?? 0]! +
                      AppUtils.instance.calculateAQI(
                        sensorData,
                        model
                            .stationRecordMap[station.stationId]?.first.records!
                            .singleWhere(
                              (r) => r.sensorId == stationSensor.sensorId,
                              orElse: () => Record(),
                            )
                            .value,
                      );
            },
          );
          if ((station.stationId ?? 0) < 100) {
            model.enableStationList.add(station);
          }

          // if (model.enableStationList
          //         .where((e) => (e.stationId ?? double.maxFinite) < 4)
          //         .length ==
          //     4) {
          //   model.focusLatLng = (model.enableStationList.first).latLng ??
          //       AppConstant.defaultLatLng;
          // }
          model.stationList.add(station);
        }
        model.isInit = true;
      } else {
        errorMessage = resStationList.message ?? '';
      }

      // BaseResponse res = BaseResponse();
      // if (rawResStationList.statusCode! < 400) {
      //   res = BaseResponse.fromJson(
      //     rawResStationList.data,
      //   );
      //   final data = res.data;
      //   if ((res.code ?? 600) < 400) {
      //     for (final station in data as List<dynamic>) {
      //       model.add(Station.fromJson(station));
      //       log('$runtimeType, ${Station.fromJson(station).toJson()}');
      //     }
      //     log('$runtimeType, model length: ${model.length}');
      //     return emit(
      //       LoadedState(
      //         model,
      //         isShowLoading: false,
      //       ),
      //     );
      //   }
      // }

      emit(
        LoadedState(
          model,
          isShowLoading: false,
          errorMessage: errorMessage,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        LoadedState(
          model,
          isShowLoading: false,
          errorMessage: 'System Error',
        ),
      );
    }
  }

  String getSensorValueByStation(int stationId) {
    final MapViewModel model = latestLoadedState?.model ?? MapViewModel();
    final stationRecord = model.stationRecordMap[stationId];
    for (final Record record in stationRecord?.first.records ?? []) {
      if (record.sensorId == model.selectedSensor?.sensorId) {
        return record.value?.toStringAsFixed(1) ?? '--';
      }
    }
    return '--';
  }

  void selectSensor(Sensor sensor) {
    final MapViewModel model = latestLoadedState?.model ?? MapViewModel();
    model.selectedSensor = sensor;
    emit(LoadedState(model));
  }

  void refresh() {
    final MapViewModel model = latestLoadedState?.model ?? MapViewModel();
    model.clear();
    fetchData();
  }
}
