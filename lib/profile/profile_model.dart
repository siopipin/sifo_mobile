class ProfileModel {
  Data? data;

  ProfileModel({this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? mhswID;
  String? tahunID;
  String? bipotNama;
  String? nama;
  String? statusAwalID;
  String? statusMhswID;
  String? programID;
  String? prodiID;
  String? namaKelas;
  dynamic pA;
  dynamic foto;
  String? agama;
  dynamic alamat;
  String? kTP;
  String? handphone;
  dynamic email;
  dynamic namaIbu;
  dynamic handphoneOrtu;

  Data(
      {this.mhswID,
      this.tahunID,
      this.bipotNama,
      this.nama,
      this.statusAwalID,
      this.statusMhswID,
      this.programID,
      this.prodiID,
      this.namaKelas,
      this.pA,
      this.foto,
      this.agama,
      this.alamat,
      this.kTP,
      this.handphone,
      this.email,
      this.namaIbu,
      this.handphoneOrtu});

  Data.fromJson(Map<String, dynamic> json) {
    mhswID = json['MhswID'];
    tahunID = json['TahunID'];
    bipotNama = json['BipotNama'];
    nama = json['Nama'];
    statusAwalID = json['StatusAwalID'];
    statusMhswID = json['StatusMhswID'];
    programID = json['ProgramID'];
    prodiID = json['ProdiID'];
    namaKelas = json['NamaKelas'];
    pA = json['PA'];
    foto = json['Foto'];
    agama = json['Agama'];
    alamat = json['Alamat'];
    kTP = json['KTP'];
    handphone = json['Handphone'];
    email = json['Email'];
    namaIbu = json['NamaIbu'];
    handphoneOrtu = json['HandphoneOrtu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MhswID'] = this.mhswID;
    data['TahunID'] = this.tahunID;
    data['BipotNama'] = this.bipotNama;
    data['Nama'] = this.nama;
    data['StatusAwalID'] = this.statusAwalID;
    data['StatusMhswID'] = this.statusMhswID;
    data['ProgramID'] = this.programID;
    data['ProdiID'] = this.prodiID;
    data['NamaKelas'] = this.namaKelas;
    data['PA'] = this.pA;
    data['Foto'] = this.foto;
    data['Agama'] = this.agama;
    data['Alamat'] = this.alamat;
    data['KTP'] = this.kTP;
    data['Handphone'] = this.handphone;
    data['Email'] = this.email;
    data['NamaIbu'] = this.namaIbu;
    data['HandphoneOrtu'] = this.handphoneOrtu;
    return data;
  }
}
