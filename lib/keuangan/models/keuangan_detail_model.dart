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
  String? tanggal;
  String? namaPembayaran;
  int? jumlah;

  Data({this.tanggal, this.namaPembayaran, this.jumlah});

  Data.fromJson(Map<String, dynamic> json) {
    tanggal = json['Tanggal'];
    namaPembayaran = json['Nama Pembayaran'];
    jumlah = json['jumlah'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Tanggal'] = this.tanggal;
    data['Nama Pembayaran'] = this.namaPembayaran;
    data['jumlah'] = this.jumlah;
    return data;
  }
}
