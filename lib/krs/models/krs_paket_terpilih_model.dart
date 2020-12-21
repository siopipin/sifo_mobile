class KRSPaketTerpilihModel {
  List<Data> data;

  KRSPaketTerpilihModel({this.data});

  KRSPaketTerpilihModel.fromJson(Map<String, dynamic> json) {
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
  int mKPaketIsiID;
  int mKID;
  String mKKode;
  String namaMK;
  int sKS;
  Null jadwalID;
  Null jM;
  Null jS;
  Null namaKelas;
  Null hR;
  Null adaResponsi;
  Null dSN;
  Null gelar;
  Null nNamaJenisJadwal;
  Null tambahan;

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
      this.nNamaJenisJadwal,
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
    nNamaJenisJadwal = json['_NamaJenisJadwal'];
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
    data['_NamaJenisJadwal'] = this.nNamaJenisJadwal;
    data['Tambahan'] = this.tambahan;
    return data;
  }
}
