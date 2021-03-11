class SoldTicketsModel {
  String amount;
  String deadline;
  String phone;
  String price;
  String resultdate;
  String ticketId;
  String ticketNo;
  String time;
  String name;

  SoldTicketsModel(
      {this.amount,
        this.deadline,
        this.phone,
        this.price,
        this.resultdate,
        this.ticketId,
        this.ticketNo,
        this.name,
        this.time});

  SoldTicketsModel.fromJson(Map<dynamic, dynamic> json) {
    amount = json['amount'];
    deadline = json['deadline'];
    phone = json['phone'];
    price = json['price'];
    resultdate = json['resultdate'];
    ticketId = json['ticket_id'];
    ticketNo = json['ticket_no'];
    time = json['time'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['deadline'] = this.deadline;
    data['phone'] = this.phone;
    data['price'] = this.price;
    data['resultdate'] = this.resultdate;
    data['ticket_id'] = this.ticketId;
    data['ticket_no'] = this.ticketNo;
    data['time'] = this.time;
    data['name'] = this.name;
    return data;
  }
}