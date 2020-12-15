import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:sisfo_mobile/krs/status_krs_model.dart';
import 'package:sisfo_mobile/krs/tahun_ajaran_aktif_model.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/providers/storage.dart';

class KrsProvider extends ChangeNotifier {
  Response response;
  Client client = Client();

  String _msg = '';
  String get isMessage => _msg;
  set setMessage(val) {
    _msg = val;
    notifyListeners();
  }

  //Tahun Ajaran Aktif
  bool _loadingTahun = false;
  bool get isLoading => _loadingTahun;
  set setLoadingTahun(val) {
    _loadingTahun = val;
    notifyListeners();
  }

  bool _errorTahun = false;
  bool get isErrorTahun => _errorTahun;
  set setErrorTahun(val) {
    _errorTahun = val;
    notifyListeners();
  }

  bool _adaDataTAAktif = false;
  bool get isDataTAaktif => _adaDataTAAktif;
  set setDataTAaktif(val) {
    _adaDataTAAktif = val;
    notifyListeners();
  }

  TahunAjaranAktifModel _tahunAjaranAktifModel;
  TahunAjaranAktifModel get dataTahunAktif => _tahunAjaranAktifModel;
  set setTahunAjaranAktif(val) {
    _tahunAjaranAktifModel = val;
    notifyListeners();
  }

  doGetTahunAjaranAktif() async {
    setLoadingTahun = true;
    response = await getTahunAjaranAktif();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setTahunAjaranAktif = TahunAjaranAktifModel.fromJson(tmp);
        setDataTAaktif = true;
        await doGetStatusKRS(tahunid: dataTahunAktif.data.tahunTA);
        setMessage = 'Tahun Ajaran Aktif ditemukan';
      } else if (response.statusCode == 400) {
        setDataTAaktif = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorTahun = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorTahun = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getTahunAjaranAktif() async {
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.get('$api/mahasiswa/tahun-ajaran-aktif',
          headers: header);
      setLoadingTahun = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingTahun = false;
      setErrorTahun = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Status KRS
  bool _loadingStatusKRS = false;
  bool get isLoadingKRS => _loadingStatusKRS;
  set setLoadingKRS(val) {
    _loadingStatusKRS = val;
    notifyListeners();
  }

  bool _errorStatusKRS = false;
  bool get isErrorStatusKRS => _errorStatusKRS;
  set setErrorStatusKRS(val) {
    _errorStatusKRS = val;
    notifyListeners();
  }

  bool _adaDataStatusKRS = false;
  bool get isAdaDataStatusKRS => _adaDataStatusKRS;
  set setAdaDataStatusKRS(val) {
    _adaDataStatusKRS = val;
    notifyListeners();
  }

  StatusKRSModel _statusKRSModel;
  StatusKRSModel get dataStatusKRS => _statusKRSModel;
  set setDataStatusKRS(val) {
    _statusKRSModel = val;
    notifyListeners();
  }

  doGetStatusKRS({@required String tahunid}) async {
    setLoadingKRS = true;
    response = await getStatusKRS(tahunid: tahunid);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataStatusKRS = StatusKRSModel.fromJson(tmp);
        setAdaDataStatusKRS = true;
        print(dataStatusKRS.data.statuskrs);
        setMessage = 'Tahun Ajaran Aktif ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataStatusKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorStatusKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorStatusKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getStatusKRS({@required String tahunid}) async {
    var data = json.encode({'tahunid': tahunid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/status-krs',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingKRS = false;
      setErrorStatusKRS = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
