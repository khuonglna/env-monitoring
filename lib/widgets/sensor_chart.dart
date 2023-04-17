import 'dart:developer' as dev;
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/sensor/sensor_model.dart';
import '../models/sensor/sensor_record_model.dart';
import '../models/station/station_model.dart';
import '../utils/app_utils.dart';

class SensorChart extends StatefulWidget {
  final Sensor sensor;
  final Station station;
  final int type;
  const SensorChart({
    super.key,
    required this.sensor,
    required this.station,
    required this.type,
  });

  @override
  State<SensorChart> createState() => _SensorChartState();
}

class _SensorChartState extends State<SensorChart> {
  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = [
      Colors.cyan,
      Colors.blue,
      // Colors.transparent,
      // Colors.transparent,
    ];

    List<SensorRecord> chartDataInDay = [];
    List<SensorRecord> tempChartDataInDay = [];

    widget.station.stationRecords?.forEach(
      (stationRecord) {
        stationRecord.records?.forEach(
          (record) {
            if (record.sensorId == widget.sensor.sensorId) {
              tempChartDataInDay.add(
                SensorRecord(
                  secondSinceEpoch: stationRecord.secondSinceEpoch,
                  value: record.value,
                ),
              );
            }
          },
        );
      },
    );

    final verticalInterval = widget.type == 1
        ? 2.4583548
        : widget.type == 2
            ? 100 / 42
            : 100 / 31;

    // chartDataInDay = widget.sensor?.sensorRecords?.where(
    //   (r) {
    //     final latestRecordTime = DateTime.fromMillisecondsSinceEpoch(AppUtils
    //             .instance
    //             .getSensorMaxRecordTime(records: widget.sensor?.sensorRecords) *
    //         1000);

    //     final requiredTime = latestRecordTime.subtract(
    //       const Duration(days: 1
    //           // DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
    //           ),
    //     );

    //     return true;
    //     requiredTime.isBefore(
    //       DateTime.fromMillisecondsSinceEpoch((r.secondSinceEpoch ?? 0) * 1000),
    //     );
    //   },
    // );
    tempChartDataInDay = tempChartDataInDay
        .take(
          widget.type == 1
              ? 60
              : widget.type == 2
                  ? 80
                  : 1000,
        )
        .toList();
    tempChartDataInDay.sort(
      (a, b) => (b.secondSinceEpoch?.compareTo(
            a.secondSinceEpoch ?? 0,
          ) ??
          0),
    );

    tempChartDataInDay = tempChartDataInDay.reversed.toList();

    for (int i = 0; i < tempChartDataInDay.length; i++) {
      var element = tempChartDataInDay[i];
      chartDataInDay.add(
        SensorRecord(
          secondSinceEpoch: i,
          value: element.value,
        ),
      );
      dev.log('sensor: chartDataInDay: ${element.toJson()}');
    }

    dev.log(
        'sensor: ${widget.sensor.name} chartDataInDay: ${chartDataInDay.length}, empty list: ${chartDataInDay.where(
              (element) => element.value == 0.0,
            ).toList().length}');

    dev.log(
        'latest date: ${DateTime.fromMillisecondsSinceEpoch((chartDataInDay.first.secondSinceEpoch ?? 0) * 1000).subtract(
      const Duration(hours: 7),
    )}');

    dev.log(
        'furthest date: ${DateTime.fromMillisecondsSinceEpoch((chartDataInDay.last.secondSinceEpoch ?? 0) * 1000).subtract(
      const Duration(hours: 7),
    )}');

    dev.log(
        'end start difference: ${(chartDataInDay.map((e) => e.secondSinceEpoch as num).toList().reduce(max)) - (chartDataInDay.map((e) => e.secondSinceEpoch as num).toList().reduce(min))}');

    for (var element in chartDataInDay) {
      dev.log('sensor: chartDataInDay: ${element.toJson()}');
    }

    return chartDataInDay
                .where(
                  (element) => element.value == 0.0,
                )
                .toList()
                .length ==
            chartDataInDay.length
        ? const SizedBox.shrink()
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: AppUtils.instance.getSensorChartMaxValue(
                        records: chartDataInDay,
                      ) /
                      5,
                  verticalInterval: verticalInterval,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 24,
                    axisNameWidget: Text(
                      '${(widget.sensor.name ?? '').trim()}  ${widget.sensor.unitSymbol != null ? (widget.sensor.unitSymbol) : ''}',
                    ),
                  ),
                  bottomTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      // interval: 5,
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xff37434d),
                  ),
                ),
                maxY: AppUtils.instance
                    .getSensorMaxRecordValue(
                      records: chartDataInDay,
                    )
                    .toInt()
                    .nextDivisibleByTen
                    .toDouble(),
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    show: true,
                    spots: chartDataInDay
                        .map(
                          (e) => FlSpot(
                            (e.secondSinceEpoch ?? 0).toDouble(),
                            e.value ?? 0,
                          ),
                        )
                        .toList(),
                    isCurved: false,
                    barWidth: 1,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (
                        spot,
                        percent,
                        bar,
                        index,
                      ) {
                        return FlDotCirclePainter(
                          color: AppUtils.instance.getSensorQualityColor(
                            sensorQuality: AppUtils.instance.calculateSensorSQI(
                              sensor: widget.sensor,
                              value: spot.y,
                            ),
                          ),
                          radius: 3,
                          strokeColor: Colors.transparent,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map(
                              (color) => color.withOpacity(0.3),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
