class KeuanganMhsModel {
  List<Data>? data;

  KeuanganMhsModel({this.data});

  KeuanganMhsModel.fromJson(Map<String, dynamic> json) {
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
  String? namaTagihan;
  String? kodeVA;
  String? tahunid;
  int? jumlah;
  int? terbayar;
  dynamic tunggakan;

  Data(
      {this.namaTagihan,
      this.kodeVA,
      this.tahunid,
      this.jumlah,
      this.terbayar,
      this.tunggakan});

  Data.fromJson(Map<String, dynamic> json) {
    namaTagihan = json['NamaTagihan'];
    kodeVA = json['kodeVA'];
    tahunid = json['tahunid'];
    jumlah = json['Jumlah'];
    terbayar = json['Terbayar'];
    tunggakan = json['Tunggakan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NamaTagihan'] = this.namaTagihan;
    data['kodeVA'] = this.kodeVA;
    data['tahunid'] = this.tahunid;
    data['Jumlah'] = this.jumlah;
    data['Terbayar'] = this.terbayar;
    data['Tunggakan'] = this.tunggakan;
    return data;
  }
}
