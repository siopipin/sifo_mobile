import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:sisfo_mobile/krs/krs_model.dart';
import 'package:sisfo_mobile/krs/krs_paket_mode.dart';
import 'package:sisfo_mobile/krs/status_krs_model.dart';
import 'package:sisfo_mobile/krs/status_pengurusan_krs_model.dart';
import 'package:sisfo_mobile/krs/tahun_ajaran_aktif_model.dart';
import 'package:sisfo_mobile/krs/krs_paket_terpilih_model.dart';

import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class KrsProvider extends ChangeNotifier {
  Response response;
  Client client = Client();

  String _msg = '';
  String get isMessage => _msg;
  set setMessage(val) {
    _msg = val;
    notifyListeners();
  }

  //Tahun Ajaran Aktif
  bool _loadingTahun = false;
  bool get isLoading => _loadingTahun;
  set setLoadingTahun(val) {
    _loadingTahun = val;
    notifyListeners();
  }

  bool _errorTahun = false;
  bool get isErrorTahun => _errorTahun;
  set setErrorTahun(val) {
    _errorTahun = val;
    notifyListeners();
  }

  bool _adaDataTAAktif = false;
  bool get isDataTAaktif => _adaDataTAAktif;
  set setDataTAaktif(val) {
    _adaDataTAAktif = val;
    notifyListeners();
  }

  TahunAjaranAktifModel _tahunAjaranAktifModel;
  TahunAjaranAktifModel get dataTahunAktif => _tahunAjaranAktifModel;
  set setTahunAjaranAktif(val) {
    _tahunAjaranAktifModel = val;
    notifyListeners();
  }

  doGetTahunAjaranAktif() async {
    setLoadingTahun = true;
    response = await getTahunAjaranAktif();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setTahunAjaranAktif = TahunAjaranAktifModel.fromJson(tmp);
        setDataTAaktif = true;

        //Ambil status pengurusan KRS
        await doGetStatusPengurusanKRS();

        await doGetPaketKRS();

        await doGetStatusKRS(tahunid: dataTahunAktif.data.tahunTA);

        setMessage = 'Tahun Ajaran Aktif ditemukan';
      } else if (response.statusCode == 400) {
        setDataTAaktif = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorTahun = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorTahun = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getTahunAjaranAktif() async {
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.get('$api/mahasiswa/tahun-ajaran-aktif',
          headers: header);
      setLoadingTahun = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingTahun = false;
      setErrorTahun = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  ///Kondisi ambil paket KRS

  //TODO ganti status pengurusan KRS ke false
  bool _statusPengurusanKRS = false;

  // bool _statusPengurusanKRS = false;

  bool get isStatusKepengurusanKRS => _statusPengurusanKRS;
  set setStatusPengurusanKRS(val) {
    _statusPengurusanKRS = val;
    notifyListeners();
  }

  final DateTime now = new DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  cekStatusKepengurusanKRS() {
    String nowDate = formatter.format(now);
    print(nowDate);
    print(dataTahunAktif.data.tglKRSMulai);
    print(dataTahunAktif.data.tglKRSSelesai);

    DateTime mulai = DateTime.parse(dataTahunAktif.data.tglKRSMulai);
    DateTime selesai = DateTime.parse(dataTahunAktif.data.tglKRSSelesai);

    if (now.isBefore(mulai) && now.isBefore(selesai)) {
      setStatusPengurusanKRS = true;
    } else {
      //TODO ganti status pengurusan KRS ke false
      setStatusPengurusanKRS = false;
      // setStatusPengurusanKRS = true;
    }
  }

  bool _loadingStatusPengurusanKRS = false;
  bool get isLoadingStatusPengurusanKRS => _loadingStatusPengurusanKRS;
  set setLoadingStatusPengurusanKRS(val) {
    _loadingStatusPengurusanKRS = val;
    notifyListeners();
  }

  bool _errorStatusPengurusanKRS = false;
  bool get isErrorStatusPengurusanKRS => _errorStatusPengurusanKRS;
  set setErrorStatusPengurusanKRS(val) {
    _errorStatusPengurusanKRS = val;
    notifyListeners();
  }

  bool _adaDataStatusPengurusanKRS = false;
  bool get isAdaDataStatusPengurusanKRS => _adaDataStatusPengurusanKRS;
  set setAdaDataStatusPengurusanKRS(val) {
    _adaDataStatusPengurusanKRS = val;
    notifyListeners();
  }

  StatusPengurusanKRSModel _statusPengurusanKRSModel;
  StatusPengurusanKRSModel get dataStatusPengurusanKRS =>
      _statusPengurusanKRSModel;
  set setDataStatusPengurusanKRS(val) {
    _statusPengurusanKRSModel = val;
    notifyListeners();
  }

  doGetStatusPengurusanKRS() async {
    setLoadingStatusPengurusanKRS = true;
    response =
        await getStatusPengurusanKRS(tahunid: dataTahunAktif.data.tahunTA);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataStatusPengurusanKRS = StatusPengurusanKRSModel.fromJson(tmp);
        setAdaDataStatusPengurusanKRS = true;
        setMessage = 'Data ditemukan';

        setStatusPengurusanKRS = true;
      } else if (response.statusCode == 404) {
        setAdaDataStatusPengurusanKRS = true;
        setMessage = 'Data tidak ditemukan';

        setStatusPengurusanKRS = false;
      } else if (response.statusCode == 400) {
        setAdaDataStatusPengurusanKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorStatusPengurusanKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorStatusPengurusanKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getStatusPengurusanKRS({@required String tahunid}) async {
    var data = json.encode({'tahunid': tahunid});

    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/status-pengurusan-krs',
          headers: header, body: data);
      setLoadingStatusPengurusanKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingStatusPengurusanKRS = false;
      setStatusPengurusanKRS = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Ambil List Paket KRS
  bool _loadingPaketKRS = false;
  bool get isLoadingPaketKRS => _loadingPaketKRS;
  set setLoadingPaketKRS(val) {
    _loadingPaketKRS = val;
    notifyListeners();
  }

  bool _errorPaketKRS = false;
  bool get isErrorPaketKRS => _errorPaketKRS;
  set setErrorPaketKRS(val) {
    _errorPaketKRS = val;
    notifyListeners();
  }

  bool _adaDataPaketKRS = false;
  bool get isAdaDataPaketKRS => _adaDataPaketKRS;
  set setAdaDataPaketKRS(val) {
    _adaDataPaketKRS = val;
    notifyListeners();
  }

  PaketKRSModel _paketKRSModel;
  PaketKRSModel get dataPaketKRS => _paketKRSModel;
  set setDataPaketKRS(val) {
    _paketKRSModel = val;
    print(_paketKRSModel.data.length);
    notifyListeners();
  }

  doGetPaketKRS() async {
    setLoadingPaketKRS = true;
    response = await getPaketKRS();
    print(response.statusCode);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataPaketKRS = PaketKRSModel.fromJson(tmp);
        setAdaDataPaketKRS = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataPaketKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorPaketKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorPaketKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getPaketKRS() async {
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.get('$api/mahasiswa/krs-paket', headers: header);
      setLoadingPaketKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingPaketKRS = false;
      setErrorTahun = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Status KRS
  bool _loadingStatusKRS = false;
  bool get isLoadingStatusKRS => _loadingStatusKRS;
  set setLoadingStatusKRS(val) {
    _loadingStatusKRS = val;
    notifyListeners();
  }

  bool _errorStatusKRS = false;
  bool get isErrorStatusKRS => _errorStatusKRS;
  set setErrorStatusKRS(val) {
    _errorStatusKRS = val;
    notifyListeners();
  }

  bool _adaDataStatusKRS = false;
  bool get isAdaDataStatusKRS => _adaDataStatusKRS;
  set setAdaDataStatusKRS(val) {
    _adaDataStatusKRS = val;
    notifyListeners();
  }

  StatusKRSModel _statusKRSModel;
  StatusKRSModel get dataStatusKRS => _statusKRSModel;
  set setDataStatusKRS(val) {
    _statusKRSModel = val;
    notifyListeners();
  }

  doGetStatusKRS({@required String tahunid}) async {
    setLoadingStatusKRS = true;
    response = await getStatusKRS(tahunid: tahunid);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataStatusKRS = StatusKRSModel.fromJson(tmp);
        setAdaDataStatusKRS = true;

        //Ambil KRS ketika ada khsid
        await doGetKRS(khsid: dataStatusKRS.data.kHSID);

        setMessage = 'Status KRS ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataStatusKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorStatusKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorStatusKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getStatusKRS({@required String tahunid}) async {
    var data = json.encode({'tahunid': tahunid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/status-krs',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingStatusKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingStatusKRS = false;
      setErrorStatusKRS = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Status KRS
  bool _loadingKrs = false;
  bool get isLoadingKRS => _loadingKrs;
  set setLoadingKRS(val) {
    _loadingKrs = val;
    notifyListeners();
  }

  bool _errorKRS = false;
  bool get isErrorKRS => _errorKRS;
  set setErrorKRS(val) {
    _errorKRS = val;
    notifyListeners();
  }

  bool _adaDataKRS = false;
  bool get isAdaDataKRS => _adaDataKRS;
  set setAdaDataKRS(val) {
    _adaDataKRS = val;
    notifyListeners();
  }

  KrsModel _krsModel;
  KrsModel get dataKRS => _krsModel;
  set setDataKRS(KrsModel val) {
    val.data.forEach((element) {
      element.isExpanded = false;
    });
    _krsModel = val;
    setHari();
    notifyListeners();
  }

  setExpanded(int index, bool status) {
    dataKRS.data[index].isExpanded = status;
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
    dataKRS.data.forEach((element) {
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

  doGetKRS({@required int khsid}) async {
    setLoadingKRS = true;
    response = await getKRS(khsid: khsid);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);

        setDataKRS = KrsModel.fromJson(tmp);
        setAdaDataKRS = true;
        setMessage = 'KRS ditemukan';
        print(dataKRS.data[0].nama);
      } else if (response.statusCode == 400) {
        setAdaDataKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getKRS({@required int khsid}) async {
    var data = json.encode({'khsid': khsid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/krs-mahasiswa',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingKRS = false;
      setErrorKRS = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  ///KRS Paket Terpilih
  bool _loadingKRSPaketTerpilih = false;
  bool get isLoadingKRSPaketTerpilih => _loadingKRSPaketTerpilih;
  set setLoadingKRSPaketTerpilih(val) {
    _loadingKRSPaketTerpilih = val;
    notifyListeners();
  }

  bool _errorKRSPaketTerpilih = false;
  bool get isErrorKRSPaketTerpilih => _errorKRSPaketTerpilih;
  set setErrorKRSPaketTerpilih(val) {
    _errorKRSPaketTerpilih = val;
    notifyListeners();
  }

  bool _adaDataKRSPaketTerpilih = false;
  bool get isAdaDataKRSPaketTerpilih => _adaDataKRSPaketTerpilih;
  set setAdaDataKRSPaketTerpilih(val) {
    _adaDataKRSPaketTerpilih = val;
    notifyListeners();
  }

  bool _pilihPaket = false;
  bool get isPilihPaket => _pilihPaket;
  set setPilihPaket(val) {
    _pilihPaket = val;
    notifyListeners();
  }

  KRSPaketTerpilihModel _krsPaketTerpilihModel;
  KRSPaketTerpilihModel get dataKRSPaketTerpilih => _krsPaketTerpilihModel;
  set setDataKRSPaketTerpilih(val) {
    _krsPaketTerpilihModel = val;
    notifyListeners();
  }

  doGetKRSPaketTerpilih(
      {@required String tahunid, @required String paketid}) async {
    setLoadingKRSPaketTerpilih = true;
    response = await getKRSPaketTerpilih(tahunid: tahunid, paketid: paketid);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataKRSPaketTerpilih = KRSPaketTerpilihModel.fromJson(tmp);
        setAdaDataKRSPaketTerpilih = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataKRSPaketTerpilih = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorKRSPaketTerpilih = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorKRSPaketTerpilih = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getKRSPaketTerpilih(
      {@required String tahunid, @required String paketid}) async {
    var data = json.encode({'tahunid': tahunid, 'paketid': paketid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/krs-paket-pilih',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingKRSPaketTerpilih = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingKRSPaketTerpilih = false;
      setErrorKRSPaketTerpilih = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //Simpan KRS
  bool _loadingSimpanKRS = false;
  bool get isLoadingSimpanKRS => _loadingSimpanKRS;
  set setLoadingSimpanKRS(val) {
    _loadingSimpanKRS = val;
    notifyListeners();
  }

  bool _errorSimpanKRS = false;
  bool get isErrorSimpanKRS => _errorSimpanKRS;
  set setErrorSimpanKRS(val) {
    _errorSimpanKRS = val;
    notifyListeners();
  }

  bool _adaDataSimpanKRS = false;
  bool get isAdaDataSimpanKRS => _adaDataSimpanKRS;
  set setAdaDataSimpanKRS(val) {
    _adaDataSimpanKRS = val;
    notifyListeners();
  }

  doGetSimpanKRS({@required String tahunid, @required String paketid}) async {
    setLoadingSimpanKRS = true;
    response = await getSimpanKRS(tahunid: tahunid, paketid: paketid);
    if (response != null) {
      if (response.statusCode == 200) {
        setAdaDataSimpanKRS = true;
        setMessage = 'Data ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataSimpanKRS = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorSimpanKRS = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorSimpanKRS = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getSimpanKRS({@required String tahunid, @required String paketid}) async {
    var data = json.encode({'tahunid': tahunid, 'paketid': paketid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/simpan-krs',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingSimpanKRS = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingSimpanKRS = false;
      setErrorSimpanKRS = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}