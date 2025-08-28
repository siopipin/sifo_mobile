class TahunAjaranAktifModel {
  Data? data;

  TahunAjaranAktifModel({this.data});

  TahunAjaranAktifModel.fromJson(Map<String, dynamic> json) {
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
  String? tahunTA;
  String? namaTA;
  String? tglKRSMulai;
  String? tglKRSSelesai;
  String? kodeID;

  Data(
      {this.tahunTA,
      this.namaTA,
      this.tglKRSMulai,
      this.tglKRSSelesai,
      this.kodeID});

  Data.fromJson(Map<String, dynamic> json) {
    tahunTA = json['tahunTA'];
    namaTA = json['namaTA'];
    tglKRSMulai = json['TglKRSMulai'];
    tglKRSSelesai = json['TglKRSSelesai'];
    kodeID = json['KodeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tahunTA'] = this.tahunTA;
    data['namaTA'] = this.namaTA;
    data['TglKRSMulai'] = this.tglKRSMulai;
    data['TglKRSSelesai'] = this.tglKRSSelesai;
    data['KodeID'] = this.kodeID;
    return data;
  }
}
