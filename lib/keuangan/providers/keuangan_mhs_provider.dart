import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/keuangan/models/keuangan_mhs_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateKeuanganMhs { initial, loading, loaded, nulldata, error }

class KeuanganMhsProvider extends ChangeNotifier {
  initial() {
    setStateKeuanganMhs = StateKeuanganMhs.initial;
    fetchKeuanganMhs();
  }

  StateKeuanganMhs _stateKeuanganMhs = StateKeuanganMhs.initial;
  StateKeuanganMhs get stateKeuanganMhs => _stateKeuanganMhs;
  set setStateKeuanganMhs(val) {
    _stateKeuanganMhs = val;
    notifyListeners();
  }

  KeuanganMhsModel _keuanganMhsModel = KeuanganMhsModel();
  KeuanganMhsModel get dataKeuanganMhs => _keuanganMhsModel;
  set setKeuanganMhsModel(val) {
    _keuanganMhsModel = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchKeuanganMhs() async {
    setStateKeuanganMhs = StateKeuanganMhs.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/keuangan-khs-v2', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateKeuanganMhs = StateKeuanganMhs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateKeuanganMhs = StateKeuanganMhs.loaded;
        setKeuanganMhsModel =
            KeuanganMhsModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateKeuanganMhs = StateKeuanganMhs.nulldata;
        Fluttertoast.showToast(msg: 'Data Keuangan tidak ditemukan');
        print(UnauthorisedException('Data Keuangan tidak ditemukan'));
        break;
      case 401:
        setStateKeuanganMhs = StateKeuanganMhs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateKeuanganMhs = StateKeuanganMhs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
