class Winner_price {
  String key;
  int no_of_winners;
  int winner_price;


  Winner_price(
      {

        this.key,
        this.no_of_winners,
        this.winner_price,

      });

  Winner_price.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }



    key = map['key'];
    no_of_winners = map['no_of_winners'];
    winner_price = map['winner_price'];


  }
  toJson() {
    return {
      'key': key,
      "total_amount": no_of_winners,
      "added_amount": winner_price,
    };
  }

  Winner_price copyWith(
      {
        String WalletId,
        String key,
      }) {
    return Winner_price(

      no_of_winners: no_of_winners ?? this.no_of_winners,
        winner_price: winner_price ?? this.winner_price,


    );
  }


}
