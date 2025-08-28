import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class HomeProvider extends ChangeNotifier {
  initial() {
    getDataAwal();
    setIndex = 0;
  }

  int _index = 0;
  int get index => _index;
  set setIndex(val) {
    _index = val;
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
    await data.showNama().then((value) {
      if (value == null) {
        setNama = '';
      } else {
        setNama = value;
      }
    });

    await data.showNPM().then((value) {
      if (value == null) {
        setNim = '';
      } else {
        setNim = value;
      }
    });
    await data.showProdi().then((value) {
      if (value == null) {
        setProdi = '';
      } else {
        setProdi = value;
      }
    });

    await data.showProgram().then((value) {
      if (value == null) {
        setProgram = '';
      } else {
        setProgram = value;
      }
    });

    await data.showStatus().then((value) {
      if (value == null) {
        setStatus = '';
      } else {
        setStatus = value;
      }
    });

    await data.showFoto().then((value) {
      if (value == null) {
        setFoto = '';
      } else {
        print('foto pada storage:${value.toString()}');
        setFoto = value;
      }
    });
  }
}
