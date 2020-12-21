class KrsModel {
  List<Data> data;

  KrsModel({this.data});

  KrsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int kRSID;
  String kodeID;
  int kHSID;
  String mhswID;
  String tahunID;
  int jadwalID;
  int jadwalResponsiID;
  int mKID;
  String mKKode;
  String nama;
  int sKS;
  String dosenID;
  String hargaStandar;
  int harga;
  int bayar;
  int tugas1;
  int tugas2;
  int tugas3;
  int tugas4;
  int tugas5;
  int presensi;
  int iPresensi;
  int uTS;
  int uAS;
  int responsi;
  int nilaiAkhir;
  String gradeNilai;
  int bobotNilai;
  String statusKRSID;
  String tinggi;
  String finalNilai;
  String setara;
  String setaraKode;
  String setaraGrade;
  String setaraNama;
  String dispensasi;
  var dispensasiOleh;
  String tanggalDispensasi;
  var catatanDispensasi;
  var catatan;
  var catatanError;
  String sedangRemedial;
  String ruangID;
  int urutanUTS;
  int urutanUAS;
  String sah;
  String loginBuat;
  String tanggalBuat;
  var loginEdit;
  var tanggalEdit;
  String nA;
  var term;
  String sync;
  String mKNama;
  int hariID;
  var namaKelas;
  String jM;
  String jS;
  int sesi;
  String adaResponsi;
  String dSN;
  String jenisJadwalID;
  String sNamaJenisJadwal;
  String tambahan;
  bool isExpanded;

  Data(
      {this.kRSID,
      this.kodeID,
      this.kHSID,
      this.mhswID,
      this.tahunID,
      this.jadwalID,
      this.jadwalResponsiID,
      this.mKID,
      this.mKKode,
      this.nama,
      this.sKS,
      this.dosenID,
      this.hargaStandar,
      this.harga,
      this.bayar,
      this.tugas1,
      this.tugas2,
      this.tugas3,
      this.tugas4,
      this.tugas5,
      this.presensi,
      this.iPresensi,
      this.uTS,
      this.uAS,
      this.responsi,
      this.nilaiAkhir,
      this.gradeNilai,
      this.bobotNilai,
      this.statusKRSID,
      this.tinggi,
      this.finalNilai,
      this.setara,
      this.setaraKode,
      this.setaraGrade,
      this.setaraNama,
      this.dispensasi,
      this.dispensasiOleh,
      this.tanggalDispensasi,
      this.catatanDispensasi,
      this.catatan,
      this.catatanError,
      this.sedangRemedial,
      this.ruangID,
      this.urutanUTS,
      this.urutanUAS,
      this.sah,
      this.loginBuat,
      this.tanggalBuat,
      this.loginEdit,
      this.tanggalEdit,
      this.nA,
      this.term,
      this.sync,
      this.mKNama,
      this.hariID,
      this.namaKelas,
      this.jM,
      this.jS,
      this.sesi,
      this.adaResponsi,
      this.dSN,
      this.jenisJadwalID,
      this.sNamaJenisJadwal,
      this.tambahan,
      this.isExpanded});

  Data.fromJson(Map<String, dynamic> json) {
    kRSID = json['KRSID'];
    kodeID = json['KodeID'];
    kHSID = json['KHSID'];
    mhswID = json['MhswID'];
    tahunID = json['TahunID'];
    jadwalID = json['JadwalID'];
    jadwalResponsiID = json['JadwalResponsiID'];
    mKID = json['MKID'];
    mKKode = json['MKKode'];
    nama = json['Nama'];
    sKS = json['SKS'];
    dosenID = json['DosenID'];
    hargaStandar = json['HargaStandar'];
    harga = json['Harga'];
    bayar = json['Bayar'];
    tugas1 = json['Tugas1'];
    tugas2 = json['Tugas2'];
    tugas3 = json['Tugas3'];
    tugas4 = json['Tugas4'];
    tugas5 = json['Tugas5'];
    presensi = json['Presensi'];
    iPresensi = json['_Presensi'];
    uTS = json['UTS'];
    uAS = json['UAS'];
    responsi = json['Responsi'];
    nilaiAkhir = json['NilaiAkhir'];
    gradeNilai = json['GradeNilai'];
    bobotNilai = json['BobotNilai'];
    statusKRSID = json['StatusKRSID'];
    tinggi = json['Tinggi'];
    finalNilai = json['Final'];
    setara = json['Setara'];
    setaraKode = json['SetaraKode'];
    setaraGrade = json['SetaraGrade'];
    setaraNama = json['SetaraNama'];
    dispensasi = json['Dispensasi'];
    dispensasiOleh = json['DispensasiOleh'];
    tanggalDispensasi = json['TanggalDispensasi'];
    catatanDispensasi = json['CatatanDispensasi'];
    catatan = json['Catatan'];
    catatanError = json['CatatanError'];
    sedangRemedial = json['SedangRemedial'];
    ruangID = json['RuangID'];
    urutanUTS = json['UrutanUTS'];
    urutanUAS = json['UrutanUAS'];
    sah = json['Sah'];
    loginBuat = json['LoginBuat'];
    tanggalBuat = json['TanggalBuat'];
    loginEdit = json['LoginEdit'];
    tanggalEdit = json['TanggalEdit'];
    nA = json['NA'];
    term = json['Term'];
    sync = json['Sync'];
    mKNama = json['MKNama'];
    hariID = json['HariID'];
    namaKelas = json['NamaKelas'];
    jM = json['JM'];
    jS = json['JS'];
    sesi = json['Sesi'];
    adaResponsi = json['AdaResponsi'];
    dSN = json['DSN'];
    jenisJadwalID = json['JenisJadwalID'];
    sNamaJenisJadwal = json['_NamaJenisJadwal'];
    tambahan = json['Tambahan'];
    isExpanded = json['isExpanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KRSID'] = this.kRSID;
    data['KodeID'] = this.kodeID;
    data['KHSID'] = this.kHSID;
    data['MhswID'] = this.mhswID;
    data['TahunID'] = this.tahunID;
    data['JadwalID'] = this.jadwalID;
    data['JadwalResponsiID'] = this.jadwalResponsiID;
    data['MKID'] = this.mKID;
    data['MKKode'] = this.mKKode;
    data['Nama'] = this.nama;
    data['SKS'] = this.sKS;
    data['DosenID'] = this.dosenID;
    data['HargaStandar'] = this.hargaStandar;
    data['Harga'] = this.harga;
    data['Bayar'] = this.bayar;
    data['Tugas1'] = this.tugas1;
    data['Tugas2'] = this.tugas2;
    data['Tugas3'] = this.tugas3;
    data['Tugas4'] = this.tugas4;
    data['Tugas5'] = this.tugas5;
    data['Presensi'] = this.presensi;
    data['_Presensi'] = this.iPresensi;
    data['UTS'] = this.uTS;
    data['UAS'] = this.uAS;
    data['Responsi'] = this.responsi;
    data['NilaiAkhir'] = this.nilaiAkhir;
    data['GradeNilai'] = this.gradeNilai;
    data['BobotNilai'] = this.bobotNilai;
    data['StatusKRSID'] = this.statusKRSID;
    data['Tinggi'] = this.tinggi;
    data['Final'] = this.finalNilai;
    data['Setara'] = this.setara;
    data['SetaraKode'] = this.setaraKode;
    data['SetaraGrade'] = this.setaraGrade;
    data['SetaraNama'] = this.setaraNama;
    data['Dispensasi'] = this.dispensasi;
    data['DispensasiOleh'] = this.dispensasiOleh;
    data['TanggalDispensasi'] = this.tanggalDispensasi;
    data['CatatanDispensasi'] = this.catatanDispensasi;
    data['Catatan'] = this.catatan;
    data['CatatanError'] = this.catatanError;
    data['SedangRemedial'] = this.sedangRemedial;
    data['RuangID'] = this.ruangID;
    data['UrutanUTS'] = this.urutanUTS;
    data['UrutanUAS'] = this.urutanUAS;
    data['Sah'] = this.sah;
    data['LoginBuat'] = this.loginBuat;
    data['TanggalBuat'] = this.tanggalBuat;
    data['LoginEdit'] = this.loginEdit;
    data['TanggalEdit'] = this.tanggalEdit;
    data['NA'] = this.nA;
    data['Term'] = this.term;
    data['Sync'] = this.sync;
    data['MKNama'] = this.mKNama;
    data['HariID'] = this.hariID;
    data['NamaKelas'] = this.namaKelas;
    data['JM'] = this.jM;
    data['JS'] = this.jS;
    data['Sesi'] = this.sesi;
    data['AdaResponsi'] = this.adaResponsi;
    data['DSN'] = this.dSN;
    data['JenisJadwalID'] = this.jenisJadwalID;
    data['_NamaJenisJadwal'] = this.sNamaJenisJadwal;
    data['Tambahan'] = this.tambahan;
    data['isExpanded'] = this.isExpanded;

    return data;
  }
}
