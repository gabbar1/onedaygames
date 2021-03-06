class UserTransactionModel {
  String amount;
  String email;
  String name;
  String status;
  String time;
  String transactionId;
  String upi;

  UserTransactionModel(
      {this.amount,
        this.email,
        this.name,
        this.status,
        this.time,
        this.transactionId,
        this.upi});

  UserTransactionModel.fromJson(Map<dynamic, dynamic> json) {
    amount = json['amount'];
    email = json['email'];
    name = json['name'];
    status = json['status'];
    time = json['time'];
    transactionId = json['transaction_id'];
    upi = json['upi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['email'] = this.email;
    data['name'] = this.name;
    data['status'] = this.status;
    data['time'] = this.time;
    data['transaction_id'] = this.transactionId;
    data['upi'] = this.upi;
    return data;
  }
}