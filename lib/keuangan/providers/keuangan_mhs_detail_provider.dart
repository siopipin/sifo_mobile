import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/keuangan/models/keuangan_detail_model.dart';
import 'package:sisfo_mobile/keuangan/models/keuangan_mhs_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateKeuanganDetail { initial, loading, loaded, nulldata, error }

class KeuanganDetailProvider extends ChangeNotifier {
  initial() {
    setStateKeuanganDetail = StateKeuanganDetail.initial;
    fetchKeuanganDetail();
  }

  StateKeuanganDetail _stateKeuanganDetail = StateKeuanganDetail.initial;
  StateKeuanganDetail get stateKeuanganDetail => _stateKeuanganDetail;
  set setStateKeuanganDetail(val) {
    _stateKeuanganDetail = val;
    notifyListeners();
  }

  KeuanganDetailModel _keuanganDetailModel = KeuanganDetailModel();
  KeuanganDetailModel get dataKeuanganDetail => _keuanganDetailModel;
  set setKeuanganDetailModel(val) {
    _keuanganDetailModel = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchKeuanganDetail() async {
    setStateKeuanganDetail = StateKeuanganDetail.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/keuangan-detail-v2', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateKeuanganDetail = StateKeuanganDetail.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateKeuanganDetail = StateKeuanganDetail.loaded;
        setKeuanganDetailModel =
            KeuanganDetailModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateKeuanganDetail = StateKeuanganDetail.nulldata;
        Fluttertoast.showToast(msg: 'Detail Keuangan tidak ditemukan');
        print(UnauthorisedException('Detail Keuangan tidak ditemukan'));
        break;
      case 401:
        setStateKeuanganDetail = StateKeuanganDetail.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateKeuanganDetail = StateKeuanganDetail.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
