import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../constants/api.dart';
import '../../constants/app_constant.dart';
import '../../main.dart';
import '../../models/sensor/sensor_model.dart';
import '../../models/station/record_model.dart';
import '../../models/station/station_model.dart';
import '../../models/station/station_record_model.dart';
import '../../models/view/map_view_model.dart';
import '../../service/request_service.dart';
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
      (timer) async {
        log('$runtimeType, data refreshed');
        await fetchData();
        for (var station in model.stationList) {
          if ((model.stationRecordMap[station.stationId]?.first.stationSQI ??
                  0) >
              100) {
            if (Platform.isAndroid) {
              const AndroidNotificationDetails androidNotificationDetails =
                  AndroidNotificationDetails(
                '1',
                'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
              );
              const NotificationDetails notificationDetails =
                  NotificationDetails(android: androidNotificationDetails);
              await flutterLocalNotificationsPlugin?.show(
                1,
                'Cảnh báo',
                'Có điểm bất thường ở trạm ${station.name} ',
                notificationDetails,
                payload: 'item x',
              );
            } else if (Platform.isIOS) {
              const DarwinNotificationDetails iosNotificationDetails =
                  DarwinNotificationDetails(
                presentAlert: true,
              );
              const NotificationDetails notificationDetails =
                  NotificationDetails(
                iOS: iosNotificationDetails,
              );
              await flutterLocalNotificationsPlugin?.show(
                0,
                'Cảnh báo',
                'Có điểm bất thường ở trạm ${station.name} ',
                notificationDetails,
                payload: 'item x',
              );
            }
          }
        }
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
    _rotateSensorTimer?.cancel();
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
          if (station.sensors != null) {
            for (int i = 0; i < station.sensors!.length; i++) {
              Sensor sSensor = station.sensors![i];
              final sensorIndex = model.sensorList.indexWhere(
                (s) => s.sensorId == sSensor.sensorId,
              );
              if (sensorIndex > -1) {
                station.sensors![i] = model.sensorList.singleWhere(
                  (s) => s.sensorId == sSensor.sensorId,
                );
              }
            }
          }

          // Get station data
          final resListStationData = await RequestService.instance.get(
            API.stationData,
            query: {
              'station_id': station.stationId,
              // 'data_count' : 1,
              // 'start_date' : '2023-04-04',
              // 'end_date' : '2023-04-05',
            },
          );

          if ((resListStationData.code ?? 600) < 400) {
            model.stationRecordMap.clear();

            for (final resStationData
                in resListStationData.data as List<dynamic>) {
              final stationRecord = StationRecord.fromJson(resStationData);
              station.stationRecords?.add(stationRecord);
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
                (a, b) => b.secondSinceEpoch!.compareTo(a.secondSinceEpoch!),
              );
            }
          }

          model.stationSensorQuality.addAll(
            {station.stationId ?? 0: 0},
          );

          model.stationRecordMap[station.stationId]?.forEach(
            (sR) {
              sR.calculateStationSQI(model.sensorList);
            },
          );

          if (station.name?.contains('SC') ?? false) {
            model.enableStationList.add(station);
          }

          model.stationList.add(station);
        }
        model.isInit = true;
      } else {
        errorMessage = resStationList.message ?? '';
      }

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
