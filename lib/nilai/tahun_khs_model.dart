class TahunKHS {
  List<Data>? data;

  TahunKHS({this.data});

  TahunKHS.fromJson(Map<String, dynamic> json) {
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
