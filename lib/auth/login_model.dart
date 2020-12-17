class LoginModel {
  String idmhs;
  String nama;
  String hp;
  String prodi;
  String program;
  String status;
  String token;

  LoginModel(
      {this.idmhs,
      this.nama,
      this.hp,
      this.prodi,
      this.program,
      this.status,
      this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    idmhs = json['idmhs'];
    nama = json['nama'];
    hp = json['hp'];
    prodi = json['prodi'];
    program = json['program'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idmhs'] = this.idmhs;
    data['nama'] = this.nama;
    data['hp'] = this.hp;
    data['prodi'] = this.prodi;
    data['program'] = this.program;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}
