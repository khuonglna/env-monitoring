import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'router/router.dart';

class EnvironmentMonitoringApp extends StatelessWidget {
  const EnvironmentMonitoringApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme:
          // brightness == Brightness.dark
          //     ? ThemeData.dark()
          //     :
          ThemeData.light(),
          // ThemeData.dark(),
    );
  }
}
