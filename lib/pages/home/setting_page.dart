import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constant.dart';
import '../../models/view/map_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: const Text(
                'ĐĂNG XUẤT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                MapViewModel.instance.clear();
                context.go(
                  AppPath.login,
                );
              },
            ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       MapViewModel.instance.isDark = !MapViewModel.instance.isDark;
            //     });
            //   },
            //   child: const Text('Theme'),
            // ),
          ],
        ),
      ),
    );
  }
}
