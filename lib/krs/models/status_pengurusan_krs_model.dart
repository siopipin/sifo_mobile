class StatusPengurusanKRSModel {
  bool? status;
  Data? data;

  StatusPengurusanKRSModel({this.status, this.data});

  StatusPengurusanKRSModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? tgl;
  String? tglKRSOnlineMulai;
  String? tglKRSOnlineSelesai;

  Data({this.tgl, this.tglKRSOnlineMulai, this.tglKRSOnlineSelesai});

  Data.fromJson(Map<String, dynamic> json) {
    tgl = json['tgl'];
    tglKRSOnlineMulai = json['tglKRSOnlineMulai'];
    tglKRSOnlineSelesai = json['TglKRSOnlineSelesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tgl'] = this.tgl;
    data['tglKRSOnlineMulai'] = this.tglKRSOnlineMulai;
    data['TglKRSOnlineSelesai'] = this.tglKRSOnlineSelesai;
    return data;
  }
}
