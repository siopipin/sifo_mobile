import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/auth/login_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateLogin { initial, loading, loaded, nulldata, error }

class LoginProvider extends ChangeNotifier {
  initial() {
    ctrlNPM.clear();
    ctrlPassword.clear();
    setIsObscureText = true;
  }

  TextEditingController ctrlNPM = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  StateLogin _stateLogin = StateLogin.initial;
  StateLogin get stateLogin => _stateLogin;
  set setStateLogin(val) {
    _stateLogin = val;
    notifyListeners();
  }

  LoginModel _loginModel = LoginModel();
  LoginModel get dataLogin => _loginModel;
  set setLoginModel(val) {
    _loginModel = val;
    notifyListeners();
  }

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;
  set setIsObscureText(val) {
    _isObscureText = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> doLogin({required String login, password}) async {
    setStateLogin = StateLogin.loading;
    var data = {'login': login, 'password': password};
    final response = await _helper.post(url: '/auth/login', data: data);
    switch (response[0]) {
      case null:
        setStateLogin = StateLogin.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateLogin = StateLogin.loaded;
        setLoginModel = LoginModel.fromJson(json.decode(response[1]));

        await store.saveLoginData(
          npm: dataLogin.idmhs!,
          nama: dataLogin.nama!,
          prodi: dataLogin.prodi!,
          program: dataLogin.program!,
          status: dataLogin.status!,
          token: dataLogin.token!,
          foto: dataLogin.foto!,
        );

        Fluttertoast.showToast(msg: 'Selamat datang ${dataLogin.nama!}');
        break;
      case 401:
        setStateLogin = StateLogin.error;
        Fluttertoast.showToast(msg: "NPM atau kata sandi salah, coba lagi!");
        throw UnauthorisedException('Unauthorised');
      default:
        setStateLogin = StateLogin.error;
        Fluttertoast.showToast(msg: "Invalid Request");
        throw BadRequestException('Invalid Request');
    }
  }

  /// Function for SplashScreen
  doWelcome() async {
    await store.saveSplashAction(status: true);
  }
}
