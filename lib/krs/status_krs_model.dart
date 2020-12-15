class StatusKRSModel {
  Data data;

  StatusKRSModel({this.data});

  StatusKRSModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int kHSID;
  String statuskrs;

  Data({this.kHSID, this.statuskrs});

  Data.fromJson(Map<String, dynamic> json) {
    kHSID = json['KHSID'];
    statuskrs = json['statuskrs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KHSID'] = this.kHSID;
    data['statuskrs'] = this.statuskrs;
    return data;
  }
}
