import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/storage.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  final Storage _storage = Storage();

  void initial() {
    setIndex = 0;
    getDataAwal();
  }

  int _index = 0;
  int get index => _index;
  set setIndex(int val) {
    if (_index == val) return;
    _index = val;
    notifyListeners();
  }

  String _name = '';
  String get isName => _name;
  set setNama(String val) {
    if (_name == val) return;
    _name = val;
    notifyListeners();
  }

  String _nim = '';
  String get isNIM => _nim;
  set setNim(String val) {
    if (_nim == val) return;
    _nim = val;
    notifyListeners();
  }

  String _prodi = '';
  String get isProdi => _prodi;
  set setProdi(String val) {
    if (_prodi == val) return;
    _prodi = val;
    notifyListeners();
  }

  String _program = '';
  String get isProgram => _program;
  set setProgram(String val) {
    if (_program == val) return;
    _program = val;
    notifyListeners();
  }

  String _status = '';
  String get isStatus => _status;
  set setStatus(String val) {
    if (_status == val) return;
    _status = val;
    notifyListeners();
  }

  String _foto = '';
  String get dataFoto => _foto;
  set setFoto(String val) {
    if (_foto == val) return;
    _foto = val;
    notifyListeners();
  }

  Future<void> getDataAwal() async {
    final nama = await _storage.showNama();
    setNama = nama ?? '';

    final npm = await _storage.showNPM();
    setNim = npm ?? '';

    final prodi = await _storage.showProdi();
    setProdi = prodi ?? '';

    final program = await _storage.showProgram();
    setProgram = program ?? '';

    final status = await _storage.showStatus();
    setStatus = status ?? '';

    final foto = await _storage.showFoto();
    setFoto = foto ?? '';
  }
}

