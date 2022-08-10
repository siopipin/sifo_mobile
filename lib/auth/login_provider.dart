import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:sisfo_mobile/auth/login_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:toast/toast.dart';

class LoginProvider extends ChangeNotifier {
  Client client = new Client();

  bool loading = false,
      loginStatus = false,
      errorStatus = false,
      seePassword = true;
  String msg = '';
  LoginModel? _loginModel;

  LoginModel get dataMahasiswa => _loginModel!;
  bool get isLoading => loading;
  bool get islogin => loginStatus;
  bool get isError => errorStatus;
  bool get isObscureText => seePassword;
  String get isMsg => msg;

  set setLoading(val) {
    loading = val;
    notifyListeners();
  }

  set setMessage(val) {
    msg = val;
    notifyListeners();
  }

  set setLoginStatus(val) {
    loginStatus = val;
    notifyListeners();
  }

  set setError(val) {
    errorStatus = val;
    notifyListeners();
  }

  set setDataMhs(val) {
    _loginModel = val;
    notifyListeners();
  }

  set setShowPassword(val) {
    seePassword = val;
    notifyListeners();
  }

  doLogin({required String login, required String password}) async {
    setLoading = true;
    final response = await postLogin(login, password);

    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataMhs = LoginModel.fromJson(tmp);

        await store.saveLoginData(
          npm: _loginModel!.idmhs!,
          nama: _loginModel!.nama!,
          prodi: _loginModel!.prodi!,
          program: _loginModel!.program!,
          status: _loginModel!.status!,
          token: _loginModel!.token!,
          foto: _loginModel!.foto!,
        );
        Toast.show(
          'Selamat datang ${_loginModel!.nama!}',
          gravity: Toast.bottom,
        );
        setLoginStatus = true;
      } else if (response.statusCode == 401) {
        setMessage = 'NIM atau kata sandi salah!';
        setLoginStatus = false;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setLoginStatus = false;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  ///Fetch Data from server
  postLogin(String login, password) async {
    var data = json.encode({'login': login, 'password': password});

    try {
      final response = await client.post(Uri.parse('${config.api}/auth/login'),
          headers: config.header, body: data);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setError = true;
      setLoading = false;
      setMessage = 'Coba Lagi, tidak dapat menghubungkan';
    }
  }

  /// Function for SplashScreen
  doWelcome() async {
    await store.saveSplashAction(status: true);
  }
}
