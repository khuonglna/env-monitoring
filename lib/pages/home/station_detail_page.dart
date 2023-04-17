import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_constant.dart';
import '../../models/sensor/sensor_model.dart';
import '../../models/station/record_model.dart';
import '../../models/view/map_view_model.dart';
import '../../styles/color.dart';
import '../../utils/app_utils.dart';
import '../../widgets/sensor_chart.dart';

class StationDetail extends StatefulWidget {
  final int stationId;
  const StationDetail({
    super.key,
    required this.stationId,
  });

  @override
  State<StationDetail> createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  int chartType = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = MapViewModel.instance;
    final colorScheme = Theme.of(context).colorScheme;
    final station = model.stationList.singleWhere(
      (s) => s.stationId == widget.stationId,
    );
    final stationRecordValue = model.stationRecordMap[station.stationId]?.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        title: Text(
          'Cập nhật lần cuối lúc: ${DateFormat('HH:mm:ss dd-MM-yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              (model.stationRecordMap[1]?.first.secondSinceEpoch ?? 0) * 1000,
            ).subtract(
              const Duration(
                hours: 7,
              ),
            ),
          )}',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: AppColor.darkSilver,
            fontSize: 12,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const SizedBox(
            height: 8,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
              side: BorderSide(
                color: AppUtils.instance.getStationQualityColor(
                  stationSensorQuality: model
                          .stationRecordMap[station.stationId]
                          ?.first
                          .stationSQI ??
                      0,
                ),
//                strokeAlign: StrokeAlign.center,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.star_border,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                station.address ?? '',
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Tooltip(
                              message: 'Nhiệt độ',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.thermostat,
                                    size: 20,
                                  ),
                                  Text(
                                    '${stationRecordValue?.records?.singleWhere(
                                          (element) => element.sensorId == 1,
                                        ).value ?? '--'} ',
                                  ),
                                ],
                              ),
                            ),
                            Tooltip(
                              message: 'Độ ẩm',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.water_drop_outlined,
                                    size: 20,
                                  ),
                                  Text(
                                    '${stationRecordValue?.records?.singleWhere(
                                          (element) => element.sensorId == 1006,
                                        ).value ?? '--'} ',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: AppUtils.instance.getStationQualityColor(
                      stationSensorQuality: model
                              .stationRecordMap[station.stationId]
                              ?.first
                              .stationSQI ??
                          0,
                    ),
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Sensor QI',
                              ),
                              Text(
                                (model.stationRecordMap[station.stationId]
                                            ?.first.stationSQI ??
                                        0)
                                    .toStringAsFixed(2),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            AppUtils.instance.getQualityIcon(
                              model.stationRecordMap[station.stationId]?.first
                                      .stationSQI ??
                                  0,
                            ),
                            size: 50,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppUtils.instance.getStationQualityText(
                              stationSensorQuality: model
                                      .stationRecordMap[station.stationId]
                                      ?.first
                                      .stationSQI ??
                                  0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppUtils.instance.getStationQualityColor(
                      stationSensorQuality: model
                              .stationRecordMap[station.stationId]
                              ?.first
                              .stationSQI ??
                          0,
                    ),
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Oxy (%)',
                              ),
                              Text(
                                (stationRecordValue?.records
                                            ?.singleWhere(
                                              (element) =>
                                                  element.sensorId == 2,
                                              orElse: () => Record(),
                                            )
                                            .value ??
                                        '--')
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Độ pH',
                              ),
                              Text(
                                (stationRecordValue?.records
                                            ?.singleWhere(
                                              (element) =>
                                                  element.sensorId == 4,
                                              orElse: () => Record(),
                                            )
                                            .value ??
                                        '--')
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Độ mặn (‰)',
                              ),
                              Text(
                                (stationRecordValue?.records
                                            ?.singleWhere(
                                              (element) =>
                                                  element.sensorId == 3,
                                              orElse: () => Record(),
                                            )
                                            .value ??
                                        '--')
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
              side: BorderSide(
                color: AppUtils.instance.getStationQualityColor(
                  stationSensorQuality: model
                          .stationRecordMap[station.stationId]
                          ?.first
                          .stationSQI ??
                      0,
                ),
//                strokeAlign: StrokeAlign.center,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Lịch sử thông số của trạm',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        'NGÀY',
                      ),
                      onPressed: () => setState(
                        () => chartType = 1,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: const Text(
                        'TUẦN',
                      ),
                      onPressed: () => setState(
                        () => chartType = 2,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: const Text(
                        'THÁNG',
                      ),
                      onPressed: () => setState(
                        () => chartType = 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: 400,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      right: 10,
                      bottom: 16,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => AppConstant.filteredSensor
                            .contains(station.sensors?[index].sensorId)
                        ? const SizedBox.shrink()
                        : SensorChart(
                            sensor: station.sensors?[index] ?? Sensor(),
                            station: station,
                            type: chartType,
                          ),
                    separatorBuilder: (context, index) => AppConstant
                            .filteredSensor
                            .contains(station.sensors?[index].sensorId)
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 16,
                          ),
                    itemCount: station.sensors?.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
