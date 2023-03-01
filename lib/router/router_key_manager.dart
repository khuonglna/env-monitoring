import 'package:flutter/material.dart';

class RouterKeyManager {
  static final instance = RouterKeyManager();
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root_key');
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell_key');
}
