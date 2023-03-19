import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/sensor/sensor_model.dart';
import '../styles/color.dart';

class AppUtils {
  AppUtils._instance();

  static AppUtils instance = AppUtils._instance();

  factory AppUtils() {
    return instance;
  }

  double calculateAQI(
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
}
