import 'dart:developer';

import 'package:dio/dio.dart';

import '../../constants/api.dart';
import '../../models/login/auth_info.dart';
import '../../models/login/login_req.dart';
import '../../models/sensor/sensor_model.dart';
import '../../models/station/record.dart';
import '../../models/station/station_model.dart';
import '../../models/station/station_record_model.dart';
import '../../models/view/map_view_model.dart';
import '../../service/request_service.dart';
import '../../utils/app_utils.dart';
import '../base_bloc.dart';

class AuthBloc extends BaseCubit {
  AuthBloc() : super(InitialState());
  final dio = Dio();

  Future<void> login({required LoginReq loginReq}) async {
    LoginReq authModel = latestLoadedState?.model ?? LoginReq();
    MapViewModel model = MapViewModel.instance;
    String errorMessage = '';
    emit(
      LoadedState(
        authModel,
        isShowLoading: true,
      ),
    );
    try {
      final res = await RequestService.instance.get(
        API.login,
        query: {
          'userName': loginReq.userName,
          'password': loginReq.password,
          // 'userName': 'nhan',
          // 'password': 'nhan',
          // 'deviceId': '',
        },
        needAuth: false,
      );

      if ((res.code ?? 600) < 400) {
        AuthInfo.fromJson(res.data);
        log('$runtimeType, access key: ${AuthInfo.instance.accessKey.toString()}');
        log('$runtimeType, user id: ${AuthInfo.instance.userId.toString()}');
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
              if (model.stationRecordMap.isNotEmpty) {
                if (model.stationRecordMap.containsKey(station.stationId)) {
                  model.stationRecordMap[station.stationId ?? 0] = [];
                }
              }
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
                          model.stationRecordMap[station.stationId]?.first
                              .records!
                              .singleWhere(
                                (r) => r.sensorId == stationSensor.sensorId,
                                orElse: () => Record(),
                              )
                              .value,
                        );
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
        return emit(
          LoadedState(
            authModel,
            isShowLoading: false,
          ),
        );
      }

      emit(
        LoadedState(
          authModel,
          isShowLoading: false,
          errorMessage: res.message,
        ),
      );
      log('$runtimeType, $res');
    } catch (e) {
      log('\x1B[31m$e\x1B[0m');
      emit(
        LoadedState(
          authModel,
          isShowLoading: false,
          errorMessage: 'System Error',
        ),
      );
    }
  }
}
