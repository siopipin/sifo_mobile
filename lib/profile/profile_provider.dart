import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sisfo_mobile/profile/profile_model.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/providers/storage.dart';

class ProfileProvider extends ChangeNotifier {
  http.Response response;

  bool loading = false, error = false, data = false, edit = false;
  String msg = '', status = '', statusAwal = '', program = '';
  ProfileModel _profileModel;

  ProfileModel get dataMahasiswa => _profileModel;
  bool get isData => data;

  String get statusMahasiswa {
    if (data) {
      switch (dataMahasiswa.data.statusMhswID) {
        case 'A':
          return status = 'Aktif (Active)';
          break;
        case 'C':
          return status = 'Leaves (Cuti)';
          break;
        case 'D':
          return status = 'Drop Out';
          break;
        case 'L':
          return status = 'Lulus (Graduated)';
          break;
        case 'K':
          return status = 'Keluar (Out with Permit)';
          break;
        default:
          return status = 'default';
      }
    } else {
      print('data is not get successfully');
      return status = '';
    }
  }

  String get statusAwalMahasiswa {
    if (data) {
      switch (dataMahasiswa.data.statusAwalID) {
        case 'B':
          return statusAwal = 'Baru (New Studen)';
          break;
        case 'P':
          return statusAwal = 'Pindahan (Tranfer Student)';
          break;
        case 'S':
          return statusAwal = 'Beasiswa (Scholarship)';
          break;
        case 'D':
          return statusAwal = 'Pindahan Prodi (Major Transfer)';
          break;
        default:
          return status = 'default';
      }
    } else {
      print('data is not get successfully');
      return status = '';
    }
  }

  String get programId {
    if (data) {
      switch (dataMahasiswa.data.programID) {
        case 'R':
          return statusAwal = 'Reguler';
          break;
        case 'B':
          return statusAwal = 'Advanced Program';
          break;
        default:
          return status = 'default';
      }
    } else {
      print('data is not get successfully');
      return status = '';
    }
  }

  bool get isEdit => edit;
  bool get isLoading => loading;

  set setError(val) {
    error = val;
    notifyListeners();
  }

  set setLoading(val) {
    loading = val;
    notifyListeners();
  }

  set setDataStatus(val) {
    data = val;
    notifyListeners();
  }

  set setMessage(val) {
    msg = val;
    notifyListeners();
  }

  set setDataMhs(val) {
    _profileModel = val;
    notifyListeners();
  }

  set setEdit(val) {
    edit = val;
    notifyListeners();
  }

  ///fungsi get profile
  doGetProfile() async {
    setLoading = true;
    response = await getProfileMhs();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataMhs = ProfileModel.fromJson(tmp);
        setDataStatus = true;
      } else if (response.statusCode == 401) {
        setMessage = 'NIM atau kata sandi salah!';
      } else {
        setMessage = 'Silahkan coba lagi!';
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getProfileMhs() async {
    var token = await store.token();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await http.get('$api/mahasiswa/profile', headers: headerJwt);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  ///Fungsi edit profile
  doEditProfile(
      {@required String hp,
      @required String alamat,
      @required String email,
      @required String hportu}) async {
    setLoading = true;
    response = await putProfileMhs(
        hp: hp, alamat: alamat, email: email, hportu: hportu);
    if (response != null) {
      if (response.statusCode == 200) {
        setMessage = 'Data berhasil diubah';
        setEdit = false;
      } else if (response.statusCode == 401) {
        setMessage = 'Tidak dapat akses, silahkan login ulang, ';
        setEdit = false;
      } else {
        setMessage = 'Gagal menyimpan, Silahkan coba lagi!';
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  putProfileMhs(
      {@required String hp,
      @required String alamat,
      @required String email,
      @required String hportu}) async {
    var data = json
        .encode({"hp": hp, "alamat": alamat, "email": email, "hportu": hportu});
    var token = await store.token();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await http.put('$api/mahasiswa/profile-update',
          headers: headerJwt, body: data);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
