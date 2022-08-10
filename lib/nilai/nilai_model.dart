class NilaiModel {
  List<Data>? data;

  NilaiModel({this.data});

  NilaiModel.fromJson(Map<String, dynamic> json) {
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
  String? mKKode;
  String? nama;
  int? sKS;
  int? tugas1;
  int? tugas2;
  int? tugas3;
  int? vPresensi;
  int? nPresensi;
  int? uTS;
  int? uAS;
  int? nilaiAkhir;
  bool? isExpanded;

  Data(
      {this.mKKode,
      this.nama,
      this.sKS,
      this.tugas1,
      this.tugas2,
      this.tugas3,
      this.vPresensi,
      this.nPresensi,
      this.uTS,
      this.uAS,
      this.isExpanded,
      this.nilaiAkhir});

  Data.fromJson(Map<String, dynamic> json) {
    mKKode = json['MKKode'];
    nama = json['Nama'];
    sKS = json['SKS'];
    tugas1 = json['Tugas1'];
    tugas2 = json['Tugas2'];
    tugas3 = json['Tugas3'];
    vPresensi = json['vPresensi'];
    nPresensi = json['nPresensi'];
    uTS = json['UTS'];
    uAS = json['UAS'];
    nilaiAkhir = json['NilaiAkhir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MKKode'] = this.mKKode;
    data['Nama'] = this.nama;
    data['SKS'] = this.sKS;
    data['Tugas1'] = this.tugas1;
    data['Tugas2'] = this.tugas2;
    data['Tugas3'] = this.tugas3;
    data['vPresensi'] = this.vPresensi;
    data['nPresensi'] = this.nPresensi;
    data['UTS'] = this.uTS;
    data['UAS'] = this.uAS;
    data['NilaiAkhir'] = this.nilaiAkhir;
    return data;
  }
}
