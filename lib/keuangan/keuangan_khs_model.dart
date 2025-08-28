class KeuanganKHSModel {
  Data? data;

  KeuanganKHSModel({this.data});

  KeuanganKHSModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? tahunid;
  int? sesi;
  int? sks;
  int? ips;
  int? biaya;
  int? potongan;
  int? bayar;
  int? tarik;

  Data(
      {this.tahunid,
      this.sesi,
      this.sks,
      this.ips,
      this.biaya,
      this.potongan,
      this.bayar,
      this.tarik});

  Data.fromJson(Map<String, dynamic> json) {
    tahunid = json['tahunid'];
    sesi = json['sesi'];
    sks = json['sks'];
    ips = json['ips'];
    biaya = json['biaya'];
    potongan = json['potongan'];
    bayar = json['bayar'];
    tarik = json['tarik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tahunid'] = this.tahunid;
    data['sesi'] = this.sesi;
    data['sks'] = this.sks;
    data['ips'] = this.ips;
    data['biaya'] = this.biaya;
    data['potongan'] = this.potongan;
    data['bayar'] = this.bayar;
    data['tarik'] = this.tarik;
    return data;
  }
}
