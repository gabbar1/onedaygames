class NotificationModel {
  String body;
  String time;
  String title;

  NotificationModel({this.body, this.time, this.title});

  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    body = json['body'];
    time = json['time'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<dynamic, dynamic>();
    data['body'] = this.body;
    data['time'] = this.time;
    data['title'] = this.title;
    return data;
  }
}