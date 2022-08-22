class KrsPaketListModel {
  List<Data>? data;

  KrsPaketListModel({this.data});

  KrsPaketListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? mKPaketIsiID;
  int? mKID;
  String? mKKode;
  String? namaMK;
  int? sKS;
  int? jadwalID;
  String? jM;
  String? jS;
  String? namaKelas;
  String? hR;
  String? adaResponsi;
  String? dSN;
  String? gelar;
  String? sNamaJenisJadwal;
  String? tambahan;

  Data(
      {this.mKPaketIsiID,
      this.mKID,
      this.mKKode,
      this.namaMK,
      this.sKS,
      this.jadwalID,
      this.jM,
      this.jS,
      this.namaKelas,
      this.hR,
      this.adaResponsi,
      this.dSN,
      this.gelar,
      this.sNamaJenisJadwal,
      this.tambahan});

  Data.fromJson(Map<String, dynamic> json) {
    mKPaketIsiID = json['MKPaketIsiID'];
    mKID = json['MKID'];
    mKKode = json['MKKode'];
    namaMK = json['NamaMK'];
    sKS = json['SKS'];
    jadwalID = json['JadwalID'];
    jM = json['JM'];
    jS = json['JS'];
    namaKelas = json['NamaKelas'];
    hR = json['HR'];
    adaResponsi = json['AdaResponsi'];
    dSN = json['DSN'];
    gelar = json['Gelar'];
    sNamaJenisJadwal = json['_NamaJenisJadwal'];
    tambahan = json['Tambahan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MKPaketIsiID'] = this.mKPaketIsiID;
    data['MKID'] = this.mKID;
    data['MKKode'] = this.mKKode;
    data['NamaMK'] = this.namaMK;
    data['SKS'] = this.sKS;
    data['JadwalID'] = this.jadwalID;
    data['JM'] = this.jM;
    data['JS'] = this.jS;
    data['NamaKelas'] = this.namaKelas;
    data['HR'] = this.hR;
    data['AdaResponsi'] = this.adaResponsi;
    data['DSN'] = this.dSN;
    data['Gelar'] = this.gelar;
    data['_NamaJenisJadwal'] = this.sNamaJenisJadwal;
    data['Tambahan'] = this.tambahan;
    return data;
  }
}
