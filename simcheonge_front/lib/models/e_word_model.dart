class EwordModel {
  int? status;
  Data? data;

  EwordModel({this.status, this.data});

  EwordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? economicWord;
  String? economicWordDescription;

  Data({this.economicWord, this.economicWordDescription});

  Data.fromJson(Map<String, dynamic> json) {
    economicWord = json['economicWord'];
    economicWordDescription = json['economicWordDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['economicWord'] = economicWord;
    data['economicWordDescription'] = economicWordDescription;
    return data;
  }
}
