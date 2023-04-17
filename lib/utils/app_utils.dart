import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/sensor/sensor_model.dart';
import '../models/sensor/sensor_record_model.dart';
import '../styles/color.dart';

class AppUtils {
  AppUtils._instance();

  static AppUtils instance = AppUtils._instance();

  factory AppUtils() {
    return instance;
  }

  double calculateSQI(
    Sensor sensor,
    double? currentValue,
  ) {
    final average = (sensor.upperBound! + sensor.lowerBound!) / 2;

    if (currentValue == null) {
      return 0;
    }

    return (currentValue - average).abs() * sensor.differBound!;
  }

  IconData getQualityIcon(double qualityValue) {
    if (0 < qualityValue && qualityValue <= 50) {
      return Icons.sentiment_very_satisfied_rounded;
    } else if (50 < qualityValue && qualityValue <= 100) {
      return Icons.sentiment_neutral_rounded;
    } else if (100 < qualityValue && qualityValue <= 150) {
      return Icons.sentiment_dissatisfied_rounded;
    } else {
      return Icons.masks_rounded;
    }
  }

  Color getStationQualityColor({required double stationSensorQuality}) {
    if (0 < stationSensorQuality && stationSensorQuality <= 50) {
      return AppColor.darkLemonLime;
    } else if (50 < stationSensorQuality && stationSensorQuality <= 100) {
      return Colors.yellow;
    } else if (100 < stationSensorQuality && stationSensorQuality <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color getSensorQualityColor({required double sensorQuality}) {
    if (0 < sensorQuality && sensorQuality <= 10) {
      return AppColor.darkLemonLime;
    } else if (10 < sensorQuality && sensorQuality <= 20) {
      return Colors.yellow;
    } else if (20 < sensorQuality && sensorQuality <= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double getSensorChartMaxValue({List<SensorRecord>? records}) {
    final maxIndex = getSensorMaxRecordValue(records: records);
    if (0 < maxIndex && maxIndex <= 10) {
      return 20;
    } else if (10 < maxIndex && maxIndex <= 20) {
      return 30;
    } else if (20 < maxIndex && maxIndex <= 30) {
      return 40;
    } else {
      return 50;
    }
  }

  double getSensorMaxRecordValue({List<SensorRecord>? records}) {
    if (records == null || records.isEmpty) {
      return 0;
    } else {
      final listIndex = records.map((e) => e.value as num).toList();

      return listIndex.reduce(max).toDouble();
    }
  }

  double getSensorMinRecordValue({List<SensorRecord>? records}) {
    if (records == null || records.isEmpty) {
      return 0;
    } else {
      final listIndex = records.map((e) => e.value as num).toList();

      return listIndex.reduce(min).toDouble();
    }
  }

  int getSensorMaxRecordTime({List<SensorRecord>? records}) {
    if (records == null || records.isEmpty) {
      return 0;
    } else {
      final listIndex = records.map((e) => e.secondSinceEpoch as num).toList();

      return listIndex.reduce(max).toInt();
    }
  }

  int getSensorMinRecordTime({List<SensorRecord>? records}) {
    if (records == null || records.isEmpty) {
      return 0;
    } else {
      final listIndex = records.map((e) => e.secondSinceEpoch as num).toList();

      return listIndex.reduce(min).toInt();
    }
  }

  String getStationQualityText({required double stationSensorQuality}) {
    if (0 < stationSensorQuality && stationSensorQuality <= 50) {
      return 'Tốt';
    } else if (50 < stationSensorQuality && stationSensorQuality <= 100) {
      return 'Trung Bình';
    } else if (100 < stationSensorQuality && stationSensorQuality <= 150) {
      return 'Kém';
    } else {
      return 'Xấu';
    }
  }

  int getRandomInt() {
    int intValue = 0;
    while (intValue == 0 || intValue < 1000000000) {
      final firstMax = math.Random().nextInt(4294967296);
      final secondMax = math.Random().nextInt(4294967296);
      intValue = math.pow(firstMax * secondMax, 1000).abs().toInt();
    }

    return intValue.toInt();
  }

  double calculateSensorSQI({
    required Sensor sensor,
    required double? value,
  }) {
    final average = (sensor.upperBound! + sensor.lowerBound!) / 2;

    if (value == null) {
      return 0;
    }

    return (value - average).abs() * sensor.differBound!;
  }

  int get oneDayFromNowInSecond =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000 - 24 * 60 * 60;
  int get oneWeekFromNowInSecond => 7 * oneDayFromNowInSecond;
  int get oneMonthFromNowInSecond =>
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day *
      oneDayFromNowInSecond;
  int get sevenHoursInSecond => 60 * 60 * 7;
}

extension CustomIntegerExtension on int {
  int get nextDivisibleByTen => (this ~/ 10 + 1) * 10;
}
