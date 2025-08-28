class KeuanganDetailModel {
  List<Data>? data;

  KeuanganDetailModel({this.data});

  KeuanganDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? tahunid;
  String? nama;
  int? jumlah;
  int? besar;
  int? dibayar;

  Data({this.tahunid, this.nama, this.jumlah, this.besar, this.dibayar});

  Data.fromJson(Map<String, dynamic> json) {
    tahunid = json['tahunid'];
    nama = json['nama'];
    jumlah = json['jumlah'];
    besar = json['besar'];
    dibayar = json['dibayar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tahunid'] = this.tahunid;
    data['nama'] = this.nama;
    data['jumlah'] = this.jumlah;
    data['besar'] = this.besar;
    data['dibayar'] = this.dibayar;
    return data;
  }
}
