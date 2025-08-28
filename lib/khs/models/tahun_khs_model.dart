class TahunKhsModel {
  bool? status;
  String? message;
  List<Data>? data;

  TahunKhsModel({this.status, this.message, this.data});

  TahunKhsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? tahunid;

  Data({this.tahunid});

  Data.fromJson(Map<String, dynamic> json) {
    tahunid = json['tahunid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tahunid'] = this.tahunid;
    return data;
  }
}
