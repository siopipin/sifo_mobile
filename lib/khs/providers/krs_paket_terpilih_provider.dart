import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/krs_paket_list_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateKrsPaketTerpilih { initial, loading, loaded, nulldata, error }

enum StateSimpanKrs { initial, loading, loaded, nulldata, error }

class KrsPaketTerpilihProvider extends ChangeNotifier {
  initial() async {
    setStateKrsPaketTerpilih = StateKrsPaketTerpilih.initial;
    setStateSimpanKrs = StateSimpanKrs.initial;
  }

  StateKrsPaketTerpilih _stateKrsPaketTerpilih = StateKrsPaketTerpilih.initial;
  StateKrsPaketTerpilih get stateKrsPaketTerpilih => _stateKrsPaketTerpilih;
  set setStateKrsPaketTerpilih(val) {
    _stateKrsPaketTerpilih = val;
    notifyListeners();
  }

  //State Simpan Krs.
  StateSimpanKrs _stateSimpanKrs = StateSimpanKrs.initial;
  StateSimpanKrs get stateSimpanKrs => _stateSimpanKrs;
  set setStateSimpanKrs(val) {
    _stateSimpanKrs = val;
    notifyListeners();
  }

  KrsPaketListModel _krsPaketTerpilihModel = KrsPaketListModel();
  KrsPaketListModel get dataKrsPaketTerpilih => _krsPaketTerpilihModel;
  set setKrsPaketTerpilih(val) {
    _krsPaketTerpilihModel = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchKrsPaketTerpilih(
      {required tahunid, required paketid}) async {
    // var tmp = 20212;
    setStateKrsPaketTerpilih = StateKrsPaketTerpilih.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/krs-paket-pilih/$tahunid/$paketid',
        needToken: true,
        token: _token);

    switch (response[0]) {
      case null:
        setStateKrsPaketTerpilih = StateKrsPaketTerpilih.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateKrsPaketTerpilih = StateKrsPaketTerpilih.loaded;
        setKrsPaketTerpilih =
            KrsPaketListModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateKrsPaketTerpilih = StateKrsPaketTerpilih.nulldata;
        Fluttertoast.showToast(msg: 'List Krs Paket tidak ditemukan');
        print(UnauthorisedException('List Krs Paket tidak ditemukan'));
        break;
      case 401:
        setStateKrsPaketTerpilih = StateKrsPaketTerpilih.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateKrsPaketTerpilih = StateKrsPaketTerpilih.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }

  //Simpan KRS
  Future<void> postSimpan({
    required kodeid,
    required khsid,
    required tahunid,
    required List<Data> dataKRS,
  }) async {
    setStateSimpanKrs = StateSimpanKrs.loading;

    var data = json.encode({
      'kodeid': kodeid,
      'khsid': khsid,
      'tahunid': tahunid,
      'data': dataKRS
    });
    var _token = await store.showToken();
    final response = await _helper.post(
        url: '/mahasiswa/simpan-krs',
        needToken: true,
        token: _token,
        data: data);

    switch (response[0]) {
      case null:
        setStateSimpanKrs = StateSimpanKrs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateSimpanKrs = StateSimpanKrs.loaded;
        Fluttertoast.showToast(msg: 'KRS Berhasil disimpan!');
        break;
      case 404:
        setStateSimpanKrs = StateSimpanKrs.nulldata;
        print(UnauthorisedException('Gagal Menyimpan KRS'));
        break;
      case 401:
        setStateSimpanKrs = StateSimpanKrs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateSimpanKrs = StateSimpanKrs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
