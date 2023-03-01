import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/constant.dart';
import '../constants/image.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: ListView(
          padding: const EdgeInsets.only(
            top: 64,
            left: 32,
            right: 32,
          ),
          children: [
            Image.asset(
              AppImage.mainIcon,
              height: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'ĐĂNG KÝ TÀI KHOẢN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 64,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Tên Đăng Nhập',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Họ',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Tên',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Số Điện Thoại',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: 'Mật Khẩu',
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _isObscured = !_isObscured,
                  ),
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: 'Xác Nhận Mật Khẩu',
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _isObscured = !_isObscured,
                  ),
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                    Colors.blue,
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'ĐĂNG KÝ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đã có tài khoản? ',
                ),
                TextButton(
                  onPressed: () {
                    context.go(AppPath.login);
                  },
                  child: const Text(
                    'Đăng nhập',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
