import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/tahun_ajaran_aktif_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateTahunAjaranAktif { initial, loading, loaded, nulldata, error }

class TahunAjaranAktifProvider extends ChangeNotifier {
  initial() async {
    setStateTahunAjaranAktif = StateTahunAjaranAktif.initial;
    setStatusPengurusanKRS = false;
    await fetchTahunAjaranAktif();
  }

  StateTahunAjaranAktif _stateTahunAjaranAktif = StateTahunAjaranAktif.initial;
  StateTahunAjaranAktif get stateTahunAjaranAktif => _stateTahunAjaranAktif;
  set setStateTahunAjaranAktif(val) {
    _stateTahunAjaranAktif = val;
    notifyListeners();
  }

  TahunAjaranAktifModel _tahunAjaranAktifModel = TahunAjaranAktifModel();
  TahunAjaranAktifModel get dataTahunAjaranAktif => _tahunAjaranAktifModel;
  set setTahunAjaranAktif(val) {
    _tahunAjaranAktifModel = val;
    notifyListeners();
  }

  bool? _statusPengurusanKRS = false;
  bool get statusPengurusanKRS => _statusPengurusanKRS!;
  set setStatusPengurusanKRS(val) {
    _statusPengurusanKRS = val;
    notifyListeners();
  }

  cekPengurusanKRS(tahunid) async {
    await fetchCekKRS(tahunid).then((value) async {
      if (value[0] == 200) {
        var statusCekKrs = json.decode(value[1]);
        if (statusCekKrs['data'] == false) {
          await fetchStatusPengurusanKRS(tahunid).then((value) {
            if (value[0] == 200) {
              var statusPengurusanKrs = json.decode(value[1]);
              if (statusPengurusanKrs['status'] == true) {
                //set boleh mengurus KRS
                setStatusPengurusanKRS = true;
                //Berikutnya Ambil paket krs.
              } else {
                print('Jadwal KRS telah selesai. Hubungi Administrasi');
              }
            }
          });
        } else {
          print(
              "Batas pengambilan / pengubahan KRS telah selesai. KRS tidak dapat diubah");
        }
      }
    });
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchTahunAjaranAktif() async {
    setStateTahunAjaranAktif = StateTahunAjaranAktif.loading;
    var _token = await store.showToken();

    final response = await _helper.get(
        url: '/mahasiswa/tahun-ajaran-aktif', needToken: true, token: _token);
    switch (response[0]) {
      case null:
        setStateTahunAjaranAktif = StateTahunAjaranAktif.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateTahunAjaranAktif = StateTahunAjaranAktif.loaded;
        setTahunAjaranAktif =
            TahunAjaranAktifModel.fromJson(json.decode(response[1]));
        await cekPengurusanKRS(dataTahunAjaranAktif.data!.tahunTA!);
        break;
      case 404:
        setStateTahunAjaranAktif = StateTahunAjaranAktif.nulldata;
        Fluttertoast.showToast(msg: 'Tahun ajaran aktif tidak ditemukan');
        throw UnauthorisedException('Tahun ajaran aktif tidak ditemukan');
      case 401:
        setStateTahunAjaranAktif = StateTahunAjaranAktif.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateTahunAjaranAktif = StateTahunAjaranAktif.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }

  Future<dynamic> fetchCekKRS(tahunid) async {
    var _token = await store.showToken();

    final response = await _helper.get(
        url: '/mahasiswa/cek-krs/$tahunid', needToken: true, token: _token);
    return response;
  }

  Future<dynamic> fetchStatusPengurusanKRS(tahunid) async {
    var _token = await store.showToken();

    final response = await _helper.get(
        url: '/mahasiswa/status-pengurusan-krs/$tahunid',
        needToken: true,
        token: _token);
    return response;
  }
}
