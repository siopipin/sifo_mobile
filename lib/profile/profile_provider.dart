import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:sisfo_mobile/profile/profile_model.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class ProfileProvider extends ChangeNotifier {
  Client client = Client();

  bool loading = false,
      error = false,
      data = false,
      edit = false,
      obsecure = true,
      gantiPassword = false;

  String msg = '', status = '', statusAwal = '', program = '';
  ProfileModel? _profileModel;

  ///TextController untuk update password
  TextEditingController _oldPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _renewPass = TextEditingController();

  TextEditingController get oldPass => _oldPass;
  TextEditingController get newPass => _newPass;
  TextEditingController get renewPass => _renewPass;

  ProfileModel get dataMahasiswa => _profileModel!;
  bool get isData => data;
  bool get isObscureText => obsecure;
  bool get isGantiPassword => gantiPassword;
  bool get isEdit => edit;
  bool get isLoading => loading;

  String get statusMahasiswa {
    if (data) {
      switch (dataMahasiswa.data!.statusMhswID) {
        case 'A':
          return status = 'Aktif (Active)';

        case 'C':
          return status = 'Leaves (Cuti)';
        case 'D':
          return status = 'Drop Out';
        case 'L':
          return status = 'Lulus (Graduated)';
        case 'K':
          return status = 'Keluar (Out with Permit)';
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
      switch (dataMahasiswa.data!.statusAwalID) {
        case 'B':
          return statusAwal = 'Baru (New Studen)';
        case 'P':
          return statusAwal = 'Pindahan (Tranfer Student)';
        case 'S':
          return statusAwal = 'Beasiswa (Scholarship)';
        case 'D':
          return statusAwal = 'Pindahan Prodi (Major Transfer)';
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
      switch (dataMahasiswa.data!.programID) {
        case 'R':
          return statusAwal = 'Reguler';
        case 'B':
          return statusAwal = 'Advanced Program';
        default:
          return status = 'default';
      }
    } else {
      print('data is not get successfully');
      return status = '';
    }
  }

  set setOldPass(val) {
    _oldPass.text = val;
    notifyListeners();
  }

  set setNewPass(val) {
    _newPass.text = val;
    notifyListeners();
  }

  set setReNewPass(val) {
    _renewPass.text = val;
    notifyListeners();
  }

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

  set setObsecure(val) {
    obsecure = val;
    notifyListeners();
  }

  set setGantiPassword(val) {
    gantiPassword = val;
    notifyListeners();
  }

  ///fungsi get profile
  doGetProfile() async {
    setLoading = true;
    final response = await getProfileMhs();
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
    var token = await store.showToken();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.get(
          Uri.parse('${config.api}/mahasiswa/profile'),
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

  ///Fungsi edit profile
  doEditProfile(
      {required String hp,
      required String alamat,
      required String email,
      required String hportu}) async {
    setLoading = true;
    final response = await putProfileMhs(
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
      {required String hp,
      required String alamat,
      required String email,
      required String hportu}) async {
    var data = json
        .encode({"hp": hp, "alamat": alamat, "email": email, "hportu": hportu});
    var token = await store.showToken();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.put(
          Uri.parse('${config.api}/mahasiswa/profile-update'),
          headers: headerJwt,
          body: data);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  /// Cek-password
  doCekPassword({
    required String password,
    required String newPassword,
  }) async {
    setLoading = true;
    final response = await postCekPassword(password: password);
    if (response != null) {
      if (response.statusCode == 200) {
        await doUpdatePassword(password: newPassword);
      } else if (response.statusCode == 401) {
        setMessage = 'Kata sandi salah! Coba lagi';
        setGantiPassword = true;
        setLoading = false;
      } else {
        setMessage = 'Coba Lagi';
        setGantiPassword = true;
        setLoading = false;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  postCekPassword({required String password}) async {
    var data = json.encode({"password": password});
    var token = await store.showToken();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.post(
          Uri.parse('${config.api}/auth/cek-password'),
          headers: headerJwt,
          body: data);
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setGantiPassword = false;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  ///Fungsi Update Password
  doUpdatePassword({required String password}) async {
    final response = await putUpdatePassword(password: password);
    if (response != null) {
      if (response.statusCode == 200) {
        setMessage = 'Kata sandi berhasil diubah';
        setGantiPassword = false;
        setNewPass = '';
        setOldPass = '';
        setReNewPass = '';
      } else if (response.statusCode == 401) {
        setMessage = 'Kata sandi salah! Coba lagi';
        setGantiPassword = true;
      } else {
        setMessage = 'Coba Lagi';
        setGantiPassword = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  putUpdatePassword({required String password}) async {
    var data = json.encode({"pass": password});
    var token = await store.showToken();
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      final response = await client.put(
          Uri.parse('${config.api}/auth/password-update'),
          headers: headerJwt,
          body: data);
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
