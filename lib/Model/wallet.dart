class Wallet {
  String key;
  String phone;
  int total_amount;
  int winning_amount;
  int added_amount;
  String time;


  Wallet(
      {
        this.phone,
        this.key,
        this.total_amount,
        this.winning_amount,
        this.added_amount,
        this.time
      });

  Wallet.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }


    phone = map['phone'];
    key = map['key'];
    total_amount = map['total_amount'];
    winning_amount = map['winning_amount'];
    added_amount = map['added_amount'];
    time = map['time'];

  }
  toJson() {
    return {
      'key': key,
      "phone": phone,
      "total_amount": total_amount,
      "added_amount": added_amount,
      "winning_amount": winning_amount,
      "time": time
    };
  }

  Wallet copyWith(
      {
        String WalletId,
        String key,
      }) {
    return Wallet(
      phone: phone ?? this.phone,
      total_amount: total_amount ?? this.total_amount,
        winning_amount: winning_amount ?? this.winning_amount,
        added_amount: added_amount ?? this.added_amount,
      time: time ?? this.time

    );
  }


}
