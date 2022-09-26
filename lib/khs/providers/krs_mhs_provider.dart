import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/krs_mhs_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateKRSMhs { initial, loading, loaded, nulldata, error }

class KrsMhsProvider extends ChangeNotifier {
  initial({required String khsid}) async {
    setStateKrsMhs = StateKRSMhs.initial;
    print('ambil data');
    await fetchKrsMhs(khsid: khsid);
  }

  StateKRSMhs _stateKrsMhs = StateKRSMhs.initial;
  StateKRSMhs get stateKrsMhs => _stateKrsMhs;
  set setStateKrsMhs(val) {
    _stateKrsMhs = val;
    notifyListeners();
  }

  KrsMhsModel _krsMhsModel = KrsMhsModel();
  KrsMhsModel get dataKrsMhs => _krsMhsModel;
  set setKrsMhs(val) {
    val.data!.forEach((element) {
      element.isExpanded = false;
    });
    _krsMhsModel = val;
    setHari();
    notifyListeners();
  }

  setExpanded(int index, bool status) {
    dataKrsMhs.data![index].isExpanded = status;
    notifyListeners();
  }

  bool senin = false,
      selasa = false,
      rabu = false,
      kamis = false,
      jumat = false,
      sabtu = false;

  bool get isSenin => senin;
  bool get isSelasa => selasa;
  bool get isRabu => rabu;
  bool get isKamis => kamis;
  bool get isJumat => jumat;
  bool get isSabtu => sabtu;

  setHari() {
    dataKrsMhs.data!.forEach((element) {
      if (element.hariID == 1) {
        senin = true;
        notifyListeners();
      } else if (element.hariID == 2) {
        selasa = true;
        notifyListeners();
      } else if (element.hariID == 3) {
        rabu = true;
        notifyListeners();
      } else if (element.hariID == 4) {
        kamis = true;
        notifyListeners();
      } else if (element.hariID == 5) {
        jumat = true;
        notifyListeners();
      } else if (element.hariID == 6) {
        sabtu = true;
        notifyListeners();
      } else {
        print('else');
      }
    });
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchKrsMhs({required String khsid}) async {
    setStateKrsMhs = StateKRSMhs.loading;
    var _token = await store.showToken();
    print('url: /mahasiswa/krs-mahasiswa/$khsid');
    final response = await _helper.get(
        url: '/mahasiswa/krs-mahasiswa/$khsid', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateKrsMhs = StateKRSMhs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateKrsMhs = StateKRSMhs.loaded;
        setKrsMhs = KrsMhsModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateKrsMhs = StateKRSMhs.nulldata;
        Fluttertoast.showToast(msg: 'Data KRS tidak ditemukan');
        throw UnauthorisedException('Data KRS tidak ditemukan');
      case 401:
        setStateKrsMhs = StateKRSMhs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateKrsMhs = StateKRSMhs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
