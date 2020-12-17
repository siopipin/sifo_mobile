import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:sisfo_mobile/keuangan/keuangan_detail_model.dart';
import 'package:sisfo_mobile/keuangan/keuangan_khs_model.dart';
import 'package:sisfo_mobile/nilai/tahun_khs_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class KeuanganProvider extends ChangeNotifier {
  Client client = new Client();
  Response response;

  String message = '';
  String get isMsg => message;
  set setMessage(val) {
    message = val;
    notifyListeners();
  }

  //Handle Respons Loading TahunKHS
  bool loading = false;
  bool get isLoading => loading;
  set setLoading(val) {
    loading = val;
    notifyListeners();
  }

  bool adaData = false;
  bool get isData => adaData;
  set setData(val) {
    adaData = val;
    notifyListeners();
  }

  bool error = false;
  bool get isError => error;
  set setError(val) {
    error = val;
    notifyListeners();
  }

  ///Handle Loading Keuangan KHS
  bool loadingKeuangan = false;
  bool get isLoadingKeuangan => loadingKeuangan;
  set setloadingKeuangan(val) {
    loadingKeuangan = val;
    notifyListeners();
  }

  bool adaDataKeuangan = false;
  bool get isDataKeuangan => adaDataKeuangan;
  set setDataKeuangan(val) {
    adaDataKeuangan = val;
    notifyListeners();
  }

  bool errorDataKeuangan = false;
  bool get isErrorKeuangan => errorDataKeuangan;
  set setErrorKeuangan(val) {
    errorDataKeuangan = val;
    notifyListeners();
  }

  ///Handle Keuangan Detail
  bool loadingKeuanganDetail = false;
  bool get isLoadingKeuanganDetail => loadingKeuanganDetail;
  set setLoadingKeuanganDetail(val) {
    loadingKeuanganDetail = val;
    notifyListeners();
  }

  bool adaDataKeuanganDetail = false;
  bool get isDataKeuanganDetail => adaDataKeuanganDetail;
  set setDataKeuanganDetail(val) {
    adaDataKeuanganDetail = val;
    notifyListeners();
  }

  bool errorKeuanganDetail = false;
  bool get isErrorKeuanganDetail => errorKeuanganDetail;
  set setErrorKeuanganDetail(val) {
    errorKeuanganDetail = val;
    notifyListeners();
  }

  String tahun = '';
  String get isTahun => tahun;
  set setTahun(val) {
    tahun = val;
    notifyListeners();
  }

  TahunKHS tahunKHS = new TahunKHS();
  TahunKHS get dataTahunKHS => tahunKHS;
  set setTahunKHS(val) {
    tahunKHS = val;
    setTahun = tahunKHS.data[0].tahunid;
    notifyListeners();
  }

  KeuanganKHSModel keuanganKHSModel = new KeuanganKHSModel();
  KeuanganKHSModel get dataKeuanganKHSModel => keuanganKHSModel;
  set setKeuanganKHS(val) {
    keuanganKHSModel = val;
    setTahun = tahunKHS.data[0].tahunid;
    notifyListeners();
  }

  KeuanganDetailModel keuanganDetailModel = new KeuanganDetailModel();
  KeuanganDetailModel get dataKeuanganDetail => keuanganDetailModel;
  set setKeuanganDetail(val) {
    keuanganDetailModel = val;
    setTahun = tahunKHS.data[0].tahunid;
    notifyListeners();
  }

  doGetTahunKHS() async {
    setLoading = true;
    response = await getTahunKHS();
    print(response.statusCode);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setTahunKHS = TahunKHS.fromJson(tmp);
        setData = true;
        setLoading = false;
        await doGetKeuanganKHS(tahun: tahun);
        await doGetKeuanganDetail(tahun: tahun);
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setError = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setError = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getTahunKHS() async {
    var token = await store.token();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response =
          await client.post('$api/mahasiswa/tahun-khs', headers: headerJwt);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  ///Fungsi untuk ambil data keuangan KHS
  doGetKeuanganKHS({@required String tahun}) async {
    setloadingKeuangan = true;
    response = await getKeuanganKHS(tahun: tahun);
    print(response.statusCode);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setKeuanganKHS = KeuanganKHSModel.fromJson(tmp);
        setDataKeuangan = true;
        setMessage = 'Data berhasil diambil';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorKeuangan = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorKeuangan = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getKeuanganKHS({@required String tahun}) async {
    var token = await store.token();
    var data = json.encode({"tahunid": tahun});
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/keuangan-khs',
          headers: header, body: data);
      setloadingKeuangan = false;
      return response;
    } catch (e) {
      print(e.toString());
      setloadingKeuangan = false;
      setErrorKeuangan = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  doGetKeuanganDetail({@required String tahun}) async {
    setLoadingKeuanganDetail = true;
    response = await getKeuanganDetail(tahun: tahun);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setKeuanganDetail = KeuanganDetailModel.fromJson(tmp);
        setDataKeuanganDetail = true;
        setMessage = 'Data berhasil diambil';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorKeuanganDetail = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorKeuanganDetail = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getKeuanganDetail({@required String tahun}) async {
    var token = await store.token();
    var data = json.encode({"tahunid": tahun});
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/keuangan-detail',
          headers: header, body: data);
      setLoadingKeuanganDetail = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingKeuanganDetail = false;
      setErrorKeuanganDetail = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
