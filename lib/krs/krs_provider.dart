import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:dio/dio.dart' as dio;
import 'package:sisfo_mobile/krs/models/cek_krs_model.dart';
import 'package:sisfo_mobile/krs/models/krs_model.dart';
import 'package:sisfo_mobile/krs/models/krs_paket_model.dart';
import 'package:sisfo_mobile/krs/models/status_krs_model.dart';
import 'package:sisfo_mobile/krs/models/status_pengurusan_krs_model.dart';
import 'package:sisfo_mobile/krs/models/tahun_ajaran_aktif_model.dart';
import 'package:sisfo_mobile/krs/models/krs_paket_terpilih_model.dart';

import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class KrsProvider extends ChangeNotifier {
  Response response;
  Client client = Client();

  bool errorKRS;
  KrsProvider() {
    print('KRSPROVIDER');
    errorKRS = false;
    doGetTahunAjaranAktif();
  }

  String _msg = '';
  String get isMessage => _msg;
  set setMessage(val) {
    _msg = val;
    notifyListeners();
  }

  String nim = '';
  String get dataNim => nim;
  set setNim(val) {
    nim = val;
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
    print('DOGETTAHUNAJARANAKTIF()');
    //Ambil Nim dari store
    var tmp = await store.npm();
    setNim = tmp;

    setLoadingTahun = true;
    response = await getTahunAjaranAktif();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setTahunAjaranAktif = TahunAjaranAktifModel.fromJson(tmp);
        setDataTAaktif = true;
        //Cek status KRS dulu
        await doGetStatusKRS(tahunid: dataTahunAktif.data.tahunTA);

        //Ambil status pengurusan KRS
        await doGetStatusPengurusanKRS();

        await doGetPaketKRS();

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
      setStatusPengurusanKRS = false;
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
    var data = json.encode({'tahunid': dataTahunAktif.data.tahunTA});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/krs-paket',
          headers: header, body: data);
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

  //Cek KRS
  bool _loadingCekKrs = false;
  bool get isLoadingCekKrs => _loadingCekKrs;
  set setLoadingCekKrs(val) {
    _loadingCekKrs = val;
    notifyListeners();
  }

  bool _errorCekKrs = false;
  bool get isErrorCekKrs => _errorCekKrs;
  set setErrorCekKrs(val) {
    _errorCekKrs = val;
    notifyListeners();
  }

  bool _adaDataCekKrs = false;
  bool get isAdaDataCekKrs => _adaDataCekKrs;
  set setAdaDataCekKrs(val) {
    _adaDataCekKrs = val;
    notifyListeners();
  }

  CekKRSModel _cekKrsModel;
  CekKRSModel get dataCekKrs => _cekKrsModel;
  set setDataCekKrs(val) {
    _cekKrsModel = val;
    notifyListeners();
  }

  doGetCekKrs({@required String tahunid}) async {
    setLoadingCekKrs = true;
    response = await getCekKrs(tahunid: tahunid);
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataCekKrs = CekKRSModel.fromJson(tmp);
        setAdaDataCekKrs = true;
        setMessage = 'Status KRS ditemukan';
      } else if (response.statusCode == 400) {
        setAdaDataCekKrs = false;
        setMessage = 'Data tidak ditemukan';
      } else if (response.statusCode == 401) {
        setMessage = 'Otentikasi tidak berhasil!';
        setErrorCekKrs = true;
      } else {
        setMessage = 'Silahkan coba lagi!';
        setErrorCekKrs = true;
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getCekKrs({@required String tahunid}) async {
    var data = json.encode({'tahunid': tahunid});
    var token = await store.token();
    final header = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await client.post('$api/mahasiswa/cek-krs',
          headers: header, body: data);
      print(response.statusCode);
      setLoadingCekKrs = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoadingCekKrs = false;
      setErrorCekKrs = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }

  //KRS Mahasiswa
  bool _loadingKrs = false;
  bool get isLoadingKRS => _loadingKrs;
  set setLoadingKRS(val) {
    _loadingKrs = val;
    notifyListeners();
  }

  //TODO fix error KRS when change user

  bool get isErrorKRS {
    return errorKRS;
  }

  set setErrorKRS(val) {
    errorKRS = val;
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

        //cek KRS
        await doGetCekKrs(tahunid: dataTahunAktif.data.tahunTA);
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
      print('getKRS / RESPONSE.STATUSCODE: ${response.statusCode}');
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

  doGetSimpanKRS() async {
    setLoadingSimpanKRS = true;
    response = await getSimpanKRS();
    if (response != null) {
      if (response.statusCode == 200) {
        setAdaDataSimpanKRS = true;
        setMessage = 'Berhasil disimpan';
      } else if (response.statusCode == 400) {
        setAdaDataSimpanKRS = false;
        setMessage = 'Tidak berhasil disimpan, coba lagi.';
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

  getSimpanKRS() async {
    var data = json.encode({
      'kodeid': dataTahunAktif.data.kodeID,
      'khsid': dataStatusKRS.data.kHSID,
      'tahunid': dataTahunAktif.data.tahunTA,
      'data': dataKRSPaketTerpilih.data
    });
    print(data);
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

  ///KRS Download
  bool _loadingPdfKRS = false;
  bool get isLoadingPdfKRS => _loadingPdfKRS;
  set setLoadingPdfKRS(val) {
    _loadingPdfKRS = val;
    notifyListeners();
  }

  bool _errorPdfKRS = false;
  bool get isErrorPdfKRS => _errorPdfKRS;
  set setErrorPdfKRS(val) {
    _errorPdfKRS = val;
    notifyListeners();
  }

  bool _adaDataPDF = false;
  bool get isDataPDF => _adaDataPDF;
  set setDataPDF(val) {
    _adaDataPDF = val;
    notifyListeners();
  }

  String pDFpath = "";
  set setPdfPath(val) {
    pDFpath = val;
    notifyListeners();
  }

  downloadPDFKRS() async {
    setLoadingPdfKRS = true;
    var data = await createFileKRSPdf();
    setPdfPath = data;
    if ((pDFpath != null || pDFpath.isNotEmpty)) {
      setDataPDF = true;
      print('Path pdf : $pDFpath');
    } else {
      setDataPDF = false;
    }
  }

  createFileKRSPdf() async {
    try {
      print("Start download file from internet!");

      final url = "$apiPdf${dataStatusKRS.data.kHSID}";
      print(url);
      final filename = url.substring(url.lastIndexOf("=") + 1);
      // var request = await HttpClient().getUrl(Uri.parse(url));
      // var response = await request.close();
      // var bytes = await consolidateHttpClientResponseBytes(response);
      var dir =
          await getExternalStorageDirectories(type: StorageDirectory.documents);
      print("Download files");

      // var knockDir =
      //     await new Directory('${dir.path}/KRS').create(recursive: true);
      await dio.Dio().download(url, '${dir[0].path}/$filename.pdf');

      var newdir = "${dir[0].path}/$filename.pdf";
      // File file =
      //     await File("${dir[0].path}/$filename.pdf").create(recursive: true);
      // await file.writeAsBytes(bytes, flush: true);
      // completer.complete(file);

      print('Berhasil Simpan');
      //Jika telah selesai download, maka loading false
      setLoadingPdfKRS = false;
      setMessage = "KRS berhasil di download!";
      return newdir;
    } catch (e) {
      setLoadingPdfKRS = false;
    }
  }
}
