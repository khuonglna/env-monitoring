import 'dart:developer';
import 'package:dio/dio.dart';

import '../../constants/api.dart';
import '../../models/auth/auth_info.dart';
import '../../models/auth/login_req.dart';
import '../../models/auth/register_req.dart';
import '../../models/sensor/sensor_model.dart';
import '../../models/station/station_model.dart';
import '../../models/station/station_record_model.dart';
import '../../models/view/map_view_model.dart';
import '../../service/request_service.dart';
import '../../utils/app_utils.dart';
import '../base_bloc.dart';

class AuthBloc extends BaseCubit {
  AuthBloc() : super(InitialState());
  final dio = Dio();

  Future<void> init() async {}

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
          'deviceId': '',
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
                // 'start_date': '2021-03-08',
                // 'end_date': '2023-04-08',
                // 'data_count': 600,
                // 'start_date': DateTime.now().subtract(
                //   Duration(
                //     days: DateTime(
                //       DateTime.now().year + 4,
                //       0,
                //     ).day,
                //   ),
                // ),
                // 'end_date': DateTime.now(),
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
        for (var station in model.stationList) {
          log('$runtimeType, ${station.toJson()}');
        }
        return emit(
          LoadedState(
            authModel,
            isShowLoading: false,
          ),
        );
      } else {
        errorMessage = res.message ?? 'Unknown Error';
      }

      emit(
        LoadedState(
          authModel,
          isShowLoading: false,
          errorMessage: errorMessage,
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

  Future<void> register(RegisterReq registerReq) async {
    LoginReq authModel = latestLoadedState?.model ?? LoginReq();
    String errorMessage = '';
    emit(
      LoadedState(
        authModel,
        isShowLoading: true,
      ),
    );
    if (registerReq.phone == null || (registerReq.phone?.isEmpty ?? false)) {
      log('$runtimeType, Hello sai sđt ròi, generate place holder');
      final holderPhone = AppUtils.instance.getRandomInt();
      log('$runtimeType, place holder: $holderPhone');
      registerReq.phone = holderPhone.toString();
    }
    try {
      final res = await RequestService.instance.get(
        API.register,
        query: registerReq.toJson(),
        needAuth: false,
      );

      if ((res.code ?? 600) < 400) {
        errorMessage = '';
      } else {
        errorMessage = res.message ?? 'Unknown Error';
      }
      emit(
        LoadedState(
          authModel,
          isShowLoading: false,
          errorMessage: errorMessage,
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
