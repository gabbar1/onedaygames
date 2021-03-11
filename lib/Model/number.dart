class Number {
  String key;
  int number;
  Number({this.key, this.number});
  Number.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    key = map['key'];
    number = map['number'];
  }

  toJson() {
    return {
      'key': key,
      'number':number
    };
  }

  Number copyWith({String NumberId, String key,}) {
    return Number(number: number ?? this.number);
  }


}
