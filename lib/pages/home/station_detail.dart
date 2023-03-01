import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/station/record.dart';
import '../../models/view/map_view_model.dart';
import '../../styles/color.dart';
import '../../utils/app_utils.dart';

class StationDetail extends StatelessWidget {
  final int stationId;
  const StationDetail({
    super.key,
    required this.stationId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = MapViewModel.instance;
    final colorScheme = Theme.of(context).colorScheme;
    final station = model.stationList.singleWhere(
      (s) => s.stationId == stationId,
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
              (model.stationRecordMap[1]!.first.secondTillEpoch ?? 0) * 1000,
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
                    stationSensorQuality:
                        model.stationSensorQuality[station.stationId] ?? 0,
                  ),
                  strokeAlign: StrokeAlign.center,
                  width: 2),
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
                                    '${stationRecordValue!.records!.singleWhere(
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
                                    '${stationRecordValue.records!.singleWhere(
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
                      stationSensorQuality:
                          model.stationSensorQuality[station.stationId] ?? 0,
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
                                (model.stationSensorQuality[
                                            station.stationId] ??
                                        0)
                                    .toStringAsFixed(2),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            AppUtils.instance.getQualityIcon(
                              model.stationSensorQuality[station.stationId] ??
                                  0,
                            ),
                            size: 50,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppUtils.instance.getStationQualityText(
                              stationSensorQuality: model.stationSensorQuality[
                                      station.stationId] ??
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
                      stationSensorQuality:
                          model.stationSensorQuality[station.stationId] ?? 0,
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
                                (stationRecordValue.records!
                                            .singleWhere(
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
                                (stationRecordValue.records!
                                            .singleWhere(
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
                                (stationRecordValue.records!
                                            .singleWhere(
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
        ],
      ),
    );
  }
}
