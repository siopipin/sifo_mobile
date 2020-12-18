class InboxModel {
  List<Data> data;

  InboxModel({this.data});

  InboxModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  String title;
  String isi;
  String mhswid;
  Null topik;
  int status;
  String tanggalKirim;
  String tanggalBaca;

  Data(
      {this.id,
      this.title,
      this.isi,
      this.mhswid,
      this.topik,
      this.status,
      this.tanggalKirim,
      this.tanggalBaca});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isi = json['isi'];
    mhswid = json['mhswid'];
    topik = json['topik'];
    status = json['status'];
    tanggalKirim = json['tanggal_kirim'];
    tanggalBaca = json['tanggal_baca'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['isi'] = this.isi;
    data['mhswid'] = this.mhswid;
    data['topik'] = this.topik;
    data['status'] = this.status;
    data['tanggal_kirim'] = this.tanggalKirim;
    data['tanggal_baca'] = this.tanggalBaca;
    return data;
  }
}
