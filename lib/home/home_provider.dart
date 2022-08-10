import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class HomeProvider extends ChangeNotifier {
  set setUpdateInfo(val) {
    notifyListeners();
  }

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

  String _foto = '';
  String get dataFoto => _foto;
  set setFoto(val) {
    _foto = val;
    notifyListeners();
  }

  getDataAwal() async {
    String tmp = await store.showNama();
    if (tmp.isEmpty) {
      setNama = tmp;
    } else {
      setNama = 'User';
    }

    String tmp2 = await store.showNPM();
    if (tmp2.isEmpty) {
      setNim = tmp2;
    } else {
      setNim = '-';
    }

    String tmp3 = await store.showProdi();
    if (tmp3.isEmpty) {
      setProdi = tmp3;
    } else {
      setProdi = '-';
    }

    String tmp4 = await store.showProgram();
    if (tmp4.isEmpty) {
      setProgram = tmp4;
    } else {
      setProgram = '-';
    }

    String tmp5 = await store.showStatus();
    if (tmp5.isEmpty) {
      setStatus = tmp5;
    } else {
      setStatus = '-';
    }

    String tmp6 = await store.showFoto();
    if (tmp6.isEmpty) {
      setFoto = tmp6;
    } else {
      setFoto = '-';
    }
  }
}
