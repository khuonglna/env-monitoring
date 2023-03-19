import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constant.dart';
import '../../models/auth/auth_info.dart';
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
              ),
              onPressed: () {
                MapViewModel.instance.clear();
                context.go(
                  AppPath.login,
                );
              },
            ),

            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                backgroundColor: const MaterialStatePropertyAll(
                  Colors.white,
                ),
                overlayColor: MaterialStatePropertyAll(
                  Colors.red.withOpacity(0.1),
                ),
                // elevation: const MaterialStatePropertyAll(0),
              ),
              child: const Text(
                'XOÁ TÀI KHOẢN',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Huỷ'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final Email email = Email(
                          body:
                              'Yêu cầu xoá tài khoản với id: ${AuthInfo.instance.userId}',
                          subject: 'Yêu cầu xoá tài khoản',
                          recipients: ['npnlab.vn@gmail.com'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(email).then(
                          (value) => context.go(
                            AppPath.login,
                          ),
                        );
                        return;
                      },
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  title: const Text('Bạn sắp xoá tài khoản của mình'),
                  content: const Text(
                    'Để xoá tài khoản, bạn cần phải gửi mail yêu cầu xoá tài khoản đến NPNLab.\nYêu cầu sẽ được xử lý trong 24 giờ',
                  ),
                ),
              ),
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
