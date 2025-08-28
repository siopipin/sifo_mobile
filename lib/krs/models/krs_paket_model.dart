class PaketKRSModel {
  List<Data>? data;

  PaketKRSModel({this.data});

  PaketKRSModel.fromJson(Map<String, dynamic> json) {
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
  int? mkpaketid;
  String? namapaket;

  Data({this.mkpaketid, this.namapaket});

  Data.fromJson(Map<String, dynamic> json) {
    mkpaketid = json['mkpaketid'];
    namapaket = json['namapaket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mkpaketid'] = this.mkpaketid;
    data['namapaket'] = this.namapaket;
    return data;
  }
}
