import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 
 saveLogin(
      {required String id, required String nama, required String token}) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('id', id);
    await prefs.setString('nama', nama);
    await prefs.setString('token', token);
  }
 
  tokenFCM() async {
    await storage.read(key: 'tokenfcm');
  }

  destroyTokenFCM() async {
    await storage.delete(key: 'tokenfcm');
  }

  saveToken({@required String val}) async {
    await storage.write(key: 'token', value: val);
  }

  saveNama({@required String val}) async {
    await storage.write(key: 'nama', value: val);
  }

  saveNPM({@required String val}) async {
    await storage.write(key: 'npm', value: val);
  }

  saveProdi({@required String val}) async {
    await storage.write(key: 'prodi', value: val);
  }

  saveProgram({@required String val}) async {
    String program = '';
    switch (val) {
      case 'R':
        program = 'Reguler';
        break;
      case 'B':
        program = 'Advanced Program';
        break;
      default:
        program = '';
        break;
    }
    await storage.write(key: 'program', value: program);
  }

  saveStatus({@required String val}) async {
    String status = '';
    switch (val) {
      case 'B':
        status = 'Baru';
        break;
      case 'P':
        status = 'Pindahan';
        break;
      case 'S':
        status = 'Beasiswa';
        break;
      case 'D':
        status = 'Pindah Prodi';
        break;
      case 'J':
        status = 'Alih Jenjang';
        break;
      default:
        status = '';
        break;
    }
    await storage.write(key: 'status', value: status);
  }

  saveSplashAction({@required String val}) async {
    /// value splash : true // false
    await storage.write(key: 'splash', value: val);

    print('berhasil simpan $val');
  }

  //Read
  token() async {
    return await storage.read(key: 'token');
  }

  splash() async {
    return await storage.read(key: 'splash');
  }

  nama() async {
    return await storage.read(key: 'nama');
  }

  npm() async {
    return await storage.read(key: 'npm');
  }

  prodi() async {
    return await storage.read(key: 'prodi');
  }

  program() async {
    return await storage.read(key: 'program');
  }

  status() async {
    return await storage.read(key: 'status');
  }

  //Destroy
  destroyToken() async {
    await storage.delete(key: 'token');
  }

  destroyNama() async {
    await storage.delete(key: 'nama');
  }

  destroyNpm() async {
    await storage.delete(key: 'npm');
  }

  destroyProdi() async {
    await storage.delete(key: 'prodi');
  }

  destroyProgram() async {
    await storage.delete(key: 'program');
  }

  destroyStatus() async {
    await storage.delete(key: 'status');
  }

  //Foto
  saveFoto({@required String val}) async {
    await storage.write(key: 'foto', value: val);
  }

  foto() async {
    return await storage.read(key: 'foto');
  }

  delFoto() async {
    await storage.delete(key: 'foto');
  }
}

final store = Storage();
