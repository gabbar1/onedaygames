class UPIModel {
  String dayLimit;
  String status;
  int todayTransaction;
  String upiId;

  UPIModel({this.dayLimit, this.status, this.todayTransaction, this.upiId});

  UPIModel.fromJson(Map<String, dynamic> json) {
    dayLimit = json['day_limit'];
    status = json['status'];
    todayTransaction = json['today_transaction'];
    upiId = json['upiId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_limit'] = this.dayLimit;
    data['status'] = this.status;
    data['today_transaction'] = this.todayTransaction;
    data['upiId'] = this.upiId;
    return data;
  }
}