class StatusKrsModel {
  bool? status;
  String? message;
  Data? data;

  StatusKrsModel({this.status, this.message, this.data});

  StatusKrsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? kHSID;
  String? statuskrs;

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
