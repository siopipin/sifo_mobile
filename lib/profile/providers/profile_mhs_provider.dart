import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/profile/profile_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateProfileMhs { initial, loading, loaded, nulldata, error }

class ProfileMhsProvider extends ChangeNotifier {
  initial() {
    setStateProfileMhs = StateProfileMhs.initial;

    //clear data
    ctrlAlamat.clear();
    ctrlEmail.clear();
    ctrlHP.clear();
    ctrlHPOrtu.clear();

    //set status ganti passwd
    setGantiPassword = false;
    setEdit = false;

    fetchProfile();
  }

  TextEditingController ctrlAlamat = TextEditingController();
  TextEditingController ctrlHP = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlHPOrtu = TextEditingController();

  StateProfileMhs _stateProfileMhs = StateProfileMhs.initial;
  StateProfileMhs get stateProfileMhs => _stateProfileMhs;
  set setStateProfileMhs(val) {
    _stateProfileMhs = val;
    notifyListeners();
  }

  ProfileModel _profileMhsModel = ProfileModel();
  ProfileModel get dataProfileMhs => _profileMhsModel;
  set setProfileMhs(val) {
    _profileMhsModel = val;
    if (dataProfileMhs.data != null) {
      initialisasiCtrl();
    }
    notifyListeners();
  }

  initialisasiCtrl() {
    ctrlAlamat.text = dataProfileMhs.data!.alamat ?? '-';
    ctrlHP.text = dataProfileMhs.data!.handphone ?? '-';
    ctrlHPOrtu.text = dataProfileMhs.data!.handphoneOrtu ?? '-';
    ctrlEmail.text = dataProfileMhs.data!.email ?? '-';
    notifyListeners();
  }

  bool _isGantiPassword = false;
  bool get isGantiPassword => _isGantiPassword;
  set setGantiPassword(val) {
    _isGantiPassword = val;
    notifyListeners();
  }

  bool _edit = false;
  bool get isEdit => _edit;
  set setEdit(val) {
    _edit = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchProfile() async {
    setStateProfileMhs = StateProfileMhs.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/profile', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateProfileMhs = StateProfileMhs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateProfileMhs = StateProfileMhs.loaded;
        setProfileMhs = ProfileModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateProfileMhs = StateProfileMhs.nulldata;
        Fluttertoast.showToast(msg: 'Krs Paket tidak ditemukan');
        print(UnauthorisedException('Krs Paket tidak ditemukan'));
        break;
      case 401:
        setStateProfileMhs = StateProfileMhs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateProfileMhs = StateProfileMhs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }

  Future<bool> updateProfile({
    required String alamat,
    required String email,
    required String hp,
    required String hpOrtu,
  }) async {
    var _status;
    var _token = await store.showToken();

    var data = json.encode({
      'hp': hp,
      'alamat': alamat,
      'email': email,
      'hportu': hpOrtu,
    });

    final response = await _helper.put(
      url: '/mahasiswa/profile-update',
      needToken: true,
      token: _token,
      data: data,
    );

    switch (response[0]) {
      case null:
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        _status = false;
        throw BadRequestException('Error During Communication');
      case 200:
        Fluttertoast.showToast(msg: 'Profile berhasil disimpan');
        _status = true;
        break;
      case 404:
        _status = false;
        Fluttertoast.showToast(msg: 'Gagal menyimpan profile');
        print(UnauthorisedException('Gagal menyimpan profile'));
        break;
      case 401:
        _status = false;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        _status = false;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }

    return _status;
  }
}
