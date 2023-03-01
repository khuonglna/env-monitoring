import 'package:flutter/material.dart';

import 'dependencies.dart';
import 'env_monitoring_app.dart';

Future<void> main() async {
  await AppDependencies.initialize();
  runApp(const EnvironmentMonitoringApp());
}
