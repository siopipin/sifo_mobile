import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:sisfo_mobile/nilai/nilai_model.dart';
import 'package:sisfo_mobile/nilai/tahun_khs_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class NilaiProvider extends ChangeNotifier {
  initial() {
    doGetTahunKHS();
  }

  Client client = Client();

  bool loading = false, error = false, adaData = false;
  String message = '';
  String tahun = '';
  TahunKHS tahunKHS = new TahunKHS();

  bool get isLoading => loading;
  bool get isError => error;
  bool get isData => adaData;

  String get isMsg => message;
  TahunKHS get dataTahunKHS => tahunKHS;

  set setLoading(val) {
    loading = val;
    notifyListeners();
  }

  set setError(val) {
    error = val;
    notifyListeners();
  }

  set setMessage(val) {
    message = val;
    notifyListeners();
  }

  set setTahunKHS(val) {
    tahunKHS = val;
    setTahun = tahunKHS.data![0].tahunid;
    notifyListeners();
  }

  set setData(val) {
    adaData = val;
    notifyListeners();
  }

  setExpanded(int index, bool status) {
    dataNilai.data![index].isExpanded = status;
    notifyListeners();
  }

  String get isTahun => tahun;
  set setTahun(val) {
    tahun = val;
    notifyListeners();
  }

  //Fungsi Ambil Tahun KHS
  doGetTahunKHS() async {
    setLoading = true;
    final response = await getTahunKHS();
    print(response.statusCode);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setTahunKHS = TahunKHS.fromJson(tmp);
        setData = true;
        await doGetNilai(tahun: dataTahunKHS.data![0].tahunid!);
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
    var token = await store.showToken();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.post(
          Uri.parse('${config.api}/mahasiswa/tahun-khs'),
          headers: headerJwt);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Fungsi ambil nilai
  bool loadingNilai = false;
  bool get isLoadingNilai => loadingNilai;
  set setLoadingNilai(val) {
    loading = val;
    notifyListeners();
  }

  bool errorNilai = false;
  bool get isErrorNilai => errorNilai;
  set setErrorNilai(val) {
    errorNilai = val;
    notifyListeners();
  }

  bool adaDataNilai = false;
  bool get isDataNilai => adaDataNilai;
  set setDataNilai(val) {
    adaDataNilai = val;
    notifyListeners();
  }

  NilaiModel nilaiModel = new NilaiModel();
  NilaiModel get dataNilai => nilaiModel;
  set setNilai(NilaiModel val) {
    val.data!.forEach((element) {
      element.isExpanded = false;
    });
    nilaiModel = val;
    notifyListeners();
  }

  doGetNilai({required String tahun}) async {
    setLoadingNilai = true;
    final response = await getNilai(tahun: tahun);
    print('doGetNilai / statusCode : ${response.statusCode}');
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setNilai = NilaiModel.fromJson(tmp);
        setDataNilai = true;
        setMessage = 'Data Nilai Berhasil direquest';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorNilai = true;
        setDataNilai = false;
      } else {
        print('doGetNilai / ELSE: else');
        setErrorNilai = true;
        setMessage = 'Silahkan coba lagi!';
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getNilai({required String tahun}) async {
    var token = await store.showToken();
    var data = json.encode({"tahunid": tahun});
    print(data);
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.post(
          Uri.parse('${config.api}/mahasiswa/nilai'),
          headers: header,
          body: data);
      setLoadingNilai = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setErrorNilai = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
