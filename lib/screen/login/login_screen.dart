import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:oem_huahuan_1013/main.dart';

const users = {
  'admin': '123456',
  'guest': '123456',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  //验证用户身份
  Future<String?> _authUser(LoginData data) {
    print(data.name);
    print(data.password);
    return Future.delayed(loginTime).then((value) {
      if (!users.containsKey(data.name)) {
        return '用户不存在';
      }
      if (!users.containsValue(data.password)) {
        return '密码错误';
      }
      return null;
    });
  }

  String? defaultEmailValidator(value) {
    if (value!.isEmpty) {
      return '请输入姓名';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _authUser,
      title: '华桓电子科技',
      userType: LoginUserType.name,
      userValidator: defaultEmailValidator,
      onRecoverPassword: (String a) {},
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const MyHomePage(
              title: '主页',
            ),
          ),
        );
      },
      // logo: ,
    );
  }
}
