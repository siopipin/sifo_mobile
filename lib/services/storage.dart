import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveLoginData({
    required String token,
    required String npm,
    required String nama,
    required String prodi,
    required String program,
    required String status,
    required String foto,
  }) async {
    final SharedPreferences prefs = await _prefs;

    String _program = '';
    String _status = '';
    switch (program) {
      case 'R':
        _program = 'Reguler';
        break;
      case 'B':
        _program = 'Advanced Program';
        break;
      default:
        _program = '';
        break;
    }

    switch (status) {
      case 'B':
        _status = 'Baru';
        break;
      case 'P':
        _status = 'Pindahan';
        break;
      case 'S':
        _status = 'Beasiswa';
        break;
      case 'D':
        _status = 'Pindah Prodi';
        break;
      case 'J':
        _status = 'Alih Jenjang';
        break;
      default:
        _status = '';
        break;
    }

    await prefs.setString('npm', npm);
    await prefs.setString('nama', nama);
    await prefs.setString('token', token);
    await prefs.setString('prodi', prodi);
    await prefs.setString('foto', foto);
    await prefs.setString('program', _program);
    await prefs.setString('status', _status);
  }

  saveFoto(val) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('foto', val);
  }

  Future<bool> removeLoginData() async {
    final SharedPreferences prefs = await _prefs;
    bool success;
    try {
      await prefs.remove('npm');
      await prefs.remove('nama');
      await prefs.remove('token');
      await prefs.remove('prodi');
      await prefs.remove('program');
      await prefs.remove('status');
      await prefs.remove('splash');
      await prefs.remove('foto');
      success = true;
    } catch (e) {
      success = false;
    }
    return success;
  }

  saveSplashAction({required bool status}) async {
    // value splash : true // false
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('splash', status);
  }

  //Read
  Future<dynamic> showNPM() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('npm');
  }

  Future<dynamic> showNama() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('nama');
  }

  Future<dynamic> showToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token');
  }

  Future<dynamic> showProdi() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('prodi');
  }

  Future<dynamic> showProgram() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('program');
  }

  Future<dynamic> showStatus() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('status');
  }

  Future<dynamic> showFoto() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('foto');
  }

  Future<dynamic> showSplash() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('splash');
  }
}

final store = Storage();
