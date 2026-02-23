import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:sisfo_mobile/nilai/nilai_model.dart';
import 'package:sisfo_mobile/nilai/tahun_khs_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class NilaiProvider extends ChangeNotifier {
  void initial() {
    doGetTahunKHS();
  }

  final Client _client = Client();

  bool _loading = false;
  bool _error = false;
  bool _adaData = false;
  String _message = '';
  String _tahun = '';
  TahunKHS _tahunKHS = TahunKHS();

  bool get isLoading => _loading;
  bool get isError => _error;
  bool get isData => _adaData;
  String get isMsg => _message;
  TahunKHS get dataTahunKHS => _tahunKHS;
  String get isTahun => _tahun;

  bool _loadingNilai = false;
  bool _errorNilai = false;
  bool _adaDataNilai = false;
  NilaiModel _nilaiModel = NilaiModel();

  bool get isLoadingNilai => _loadingNilai;
  bool get isErrorNilai => _errorNilai;
  bool get isDataNilai => _adaDataNilai;
  NilaiModel get dataNilai => _nilaiModel;

  void setExpanded(int index, bool status) {
    if (_nilaiModel.data == null || index >= _nilaiModel.data!.length) return;
    _nilaiModel.data![index].isExpanded = status;
    notifyListeners();
  }

  Future<void> doGetTahunKHS() async {
    _loading = true;
    _error = false;
    notifyListeners();

    final response = await _getTahunKHS();
    _loading = false;

    if (response == null) {
      _error = true;
      _message = 'Tidak dapat menghubungkan server';
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      final tmp = json.decode(response.body);
      _tahunKHS = TahunKHS.fromJson(tmp);
      _adaData = _tahunKHS.data != null && _tahunKHS.data!.isNotEmpty;
      if (_adaData) {
        _tahun = _tahunKHS.data!.first.tahunid ?? '';
        await doGetNilai(tahun: _tahun);
      }
    } else if (response.statusCode == 401) {
      _error = true;
      _message = 'Otentikasi tidak berhasil';
    } else {
      _error = true;
      _message = 'Silahkan coba lagi';
    }
    notifyListeners();
  }

  Future<dynamic> _getTahunKHS() async {
    final token = await store.showToken();
    try {
      return await _client.get(
        Uri.parse('${config.api}/mahasiswa/tahun-khs'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> doGetNilai({required String tahun}) async {
    _loadingNilai = true;
    _errorNilai = false;
    _tahun = tahun;
    notifyListeners();

    final response = await _getNilai(tahun: tahun);
    _loadingNilai = false;

    if (response == null) {
      _errorNilai = true;
      _message = 'Tidak dapat menghubungkan server';
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      final tmp = json.decode(response.body);
      final model = NilaiModel.fromJson(tmp);
      for (var e in model.data ?? []) {
        e.isExpanded = false;
      }
      _nilaiModel = model;
      _adaDataNilai = true;
      _message = 'Data nilai berhasil dimuat';
    } else if (response.statusCode == 401) {
      _errorNilai = true;
      _message = 'Otentikasi tidak berhasil';
      _adaDataNilai = false;
    } else {
      _errorNilai = true;
      _message = 'Silahkan coba lagi';
    }
    notifyListeners();
  }

  Future<dynamic> _getNilai({required String tahun}) async {
    final token = await store.showToken();
    try {
      return await _client.post(
        Uri.parse('${config.api}/mahasiswa/nilai'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({'tahunid': tahun}),
      );
    } catch (_) {
      return null;
    }
  }
}
