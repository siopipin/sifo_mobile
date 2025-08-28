import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/krs_paket_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateKrsPaket { initial, loading, loaded, nulldata, error }

class KrsPaketProvider extends ChangeNotifier {
  initial(tahunid) async {
    setStateKrsPaket = StateKrsPaket.initial;
    await fetchKrsPaket(tahunid);
  }

  StateKrsPaket _stateKrsPaket = StateKrsPaket.initial;
  StateKrsPaket get stateKrsPaket => _stateKrsPaket;
  set setStateKrsPaket(val) {
    _stateKrsPaket = val;
    notifyListeners();
  }

  KrsPaketModel _krsPaketModel = KrsPaketModel();
  KrsPaketModel get dataKrsPaket => _krsPaketModel;
  set setKrsPaket(val) {
    _krsPaketModel = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchKrsPaket(tahunid) async {
    // var tmp = 20212;
    setStateKrsPaket = StateKrsPaket.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/krs-paket/$tahunid', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateKrsPaket = StateKrsPaket.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateKrsPaket = StateKrsPaket.loaded;
        setKrsPaket = KrsPaketModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateKrsPaket = StateKrsPaket.nulldata;
        Fluttertoast.showToast(msg: 'Krs Paket tidak ditemukan');
        print(UnauthorisedException('Krs Paket tidak ditemukan'));
        break;
      case 401:
        setStateKrsPaket = StateKrsPaket.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateKrsPaket = StateKrsPaket.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
