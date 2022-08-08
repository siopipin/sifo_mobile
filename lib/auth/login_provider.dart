import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:sisfo_mobile/auth/login_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class LoginProvider extends ChangeNotifier {
  Response response;
  Client client = new Client();

  bool loading = false,
      loginStatus = false,
      errorStatus = false,
      seePassword = true;
  String msg = '';
  LoginModel _loginModel;

  LoginModel get dataMahasiswa => _loginModel;
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

  doLogin({@required String login, @required String password}) async {
    setLoading = true;
    response = await postLogin(login, password);

    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataMhs = LoginModel.fromJson(tmp);

        await store.saveToken(val: _loginModel.token);
        await store.saveNama(val: _loginModel.nama);
        await store.saveNPM(val: _loginModel.idmhs);
        await store.saveProdi(val: _loginModel.prodi);
        await store.saveProgram(val: _loginModel.program);
        await store.saveStatus(val: _loginModel.status);
        await store.saveFoto(val: _loginModel.foto);

        setMessage = 'Selamat Datang ${_loginModel.nama}';
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

  doLogout() async {
    await store.destroyToken();
    await store.destroyNama();
    await store.destroyNpm();
    await store.destroyProdi();
    await store.destroyProgram();
    await store.destroyStatus();
    await store.destroyTokenFCM();
    await store.delFoto();

    setMessage = 'Logout Berhasil, silahkan login ulang!';
  }

  ///Fetch Data from server
  postLogin(String login, password) async {
    var data = json.encode({'login': login, 'password': password});

    try {
      response = await client.post(Uri.parse('$api/auth/login'),
          headers: header, body: data);
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
    await store.saveSplashAction(val: 'true');
  }
}
