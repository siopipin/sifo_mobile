import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class HomeProvider extends ChangeNotifier {
  initial() {
    getDataAwal();
  }

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

  Storage data = Storage();

  getDataAwal() async {
    data.showNama().then((value) {
      if (value == null) {
        setNama = '';
      } else {
        setNama = value;
      }
    });

    data.showNPM().then((value) {
      if (value == null) {
        setNim = '';
      } else {
        setNim = value;
      }
    });
    data.showProdi().then((value) {
      if (value == null) {
        setProdi = '';
      } else {
        setProdi = value;
      }
    });

    data.showProgram().then((value) {
      if (value == null) {
        setProgram = '';
      } else {
        setProgram = value;
      }
    });

    data.showStatus().then((value) {
      if (value == null) {
        setStatus = '';
      } else {
        setStatus = value;
      }
    });

    data.showFoto().then((value) {
      if (value == null) {
        setFoto = '';
      } else {
        setFoto = value;
      }
    });
  }
}
