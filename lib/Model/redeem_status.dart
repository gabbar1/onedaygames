class Status {
  String key;
  int status;
  Status({this.key, this.status});
  Status.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    key = map['key'];
    status = map['status'];
  }

  toJson() {
    return {
      'key': key,
      'status':status
    };
  }

  Status copyWith({String NumberId, String key,}) {
    return Status(status: status ?? this.status);
  }


}
