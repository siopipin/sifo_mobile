import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class HomeProvider extends ChangeNotifier {
  String _name = '';
  String get isName => _name;
  set setNama(val) {
    _name = val;
    notifyListeners();
  }

  String _nim = '';
  String get isNIM => _nim;
  set setNim(val) {
    _nim = val;
    notifyListeners();
  }

  String _prodi = '';
  String get isProdi => _prodi;
  set setProdi(val) {
    _prodi = val;
    notifyListeners();
  }

  String _program = '';
  String get isProgram => _program;
  set setProgram(val) {
    _program = val;
    notifyListeners();
  }

  String _status = '';
  String get isStatus => _status;
  set setStatus(val) {
    _status = val;
    notifyListeners();
  }

  getDataAwal() async {
    String tmp = await store.nama();
    if (tmp != null) {
      setNama = tmp;
    } else {
      setNama = 'User';
    }

    String tmp2 = await store.npm();
    if (tmp2 != null) {
      setNim = tmp2;
    } else {
      setNim = '-';
    }

    String tmp3 = await store.prodi();
    if (tmp3 != null) {
      setProdi = tmp3;
    } else {
      setProdi = '-';
    }

    String tmp4 = await store.program();
    if (tmp4 != null) {
      setProgram = tmp4;
    } else {
      setProgram = '-';
    }

    String tmp5 = await store.status();
    if (tmp5 != null) {
      setStatus = tmp5;
    } else {
      setStatus = '-';
    }
  }
}
