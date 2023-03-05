import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/base_bloc.dart';
import '../constants/constant.dart';
import '../constants/image.dart';
import '../dependencies.dart';
import '../models/auth/register_req.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscuredPassword = true;
  bool _isObscuredRePassword = true;
  final _registerReq = RegisterReq();
  late final AuthBloc bloc;
  final _usernameTextController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    bloc = AppDependencies.injector.get<AuthBloc>();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        FocusScope.of(context).requestFocus(
          FocusNode(),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is LoadedState) {
              if (context.canPop()) {
                context.pop();
              }
              if (state.isShowLoading) {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
                return;
              }
              if ((state.errorMessage?.isNotEmpty ?? false) &&
                  state.errorMessage != null) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('OK'),
                      ),
                    ],
                    title: const Text('Error'),
                    content: Text(state.errorMessage ?? ''),
                  ),
                );
                return;
              }
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                        context.go(AppPath.login);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                  title: const Text('Success'),
                  content: const Text('Đăng ký thành công' ''),
                ),
              );
            }
          },
          builder: (context, state) {
            return ListView(
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
                  controller: _usernameTextController,
                  decoration: const InputDecoration(
                    hintText: 'Tên Đăng Nhập',
                  ),
                  onChanged: (value) => _registerReq.userName = value,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _lastNameController,
                  onChanged: (value) => _registerReq.lastName = value,
                  decoration: const InputDecoration(
                    hintText: 'Họ',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _firstNameController,
                  onChanged: (value) => _registerReq.firstName = value,
                  decoration: const InputDecoration(
                    hintText: 'Tên',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _phoneController,
                  onChanged: (value) => _registerReq.phone = value,
                  decoration: const InputDecoration(
                    hintText: 'Số Điện Thoại',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _emailController,
                  onChanged: (value) => _registerReq.email = value,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passwordController,
                  onChanged: (value) => _registerReq.password = value,
                  obscureText: _isObscuredPassword,
                  decoration: InputDecoration(
                    hintText: 'Mật Khẩu',
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _isObscuredPassword = !_isObscuredPassword,
                      ),
                      icon: Icon(
                        _isObscuredPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _rePasswordController,
                  obscureText: _isObscuredRePassword,
                  decoration: InputDecoration(
                    hintText: 'Xác Nhận Mật Khẩu',
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _isObscuredRePassword = !_isObscuredRePassword,
                      ),
                      icon: Icon(
                        _isObscuredRePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    onPressed: () {
                      if (_rePasswordController.text !=
                          _passwordController.text) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('OK'),
                              ),
                            ],
                            title: const Text('Error'),
                            content: const Text('Mật khẩu không khớp'),
                          ),
                        );
                        return;
                      }
                      bloc.register(_registerReq);
                    },
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
            );
          },
        ),
      ),
    );
  }
}
