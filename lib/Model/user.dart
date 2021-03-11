class User1 {
  String key;
  String phone;
  String email;
  String name;
  String pincode;
  String state;
  String profile;
  int user_ac;
  String user_ac_name;
  String ifsc;
  String num_of_game;
  String language;
  bool bool_lang;


  User1(
      {
        this.phone,
        this.email,
        this.key,
        this.name,
        this.pincode,
        this.profile,
        this.state,
        this.user_ac,
        this.user_ac_name,
        this.ifsc,
        this.num_of_game,
        this.language,
        this.bool_lang
      });

  User1.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }


    phone = map['phone'];
    key = map['key'];
    email = map['email'];
    pincode = map['pincode'];
    profile = map['profile'];
    state = map['state'];
    name = map['name'];
    user_ac = map['ac no'];
    user_ac_name = map['acname'];
    ifsc = map['ifsc'];
    num_of_game = map['num_of_game'].toString();
    language = map['language'];
    bool_lang = map['bool_lang'];

  }
  toJson() {
    return {
      'key': key,
      "phone": phone,
      "email": email,
      "pincode": pincode,
      "profile": profile,
      "state": state,
      "name" : name,
      "acname" : user_ac_name,
      "ac no" : user_ac,
      "ifsc" : ifsc,
      "num_of_game" : num_of_game,
      "language":language,
      "bool_lang":bool_lang
    };
  }

  User1 copyWith(
      {
        String User1Id,
        String key,
      }) {
    return User1(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      pincode: pincode ?? this.pincode,
        profile: profile ?? this.profile,
      state: state ?? this.state,
      name: name ?? this.name,
      user_ac: user_ac ?? this.user_ac,
      user_ac_name: user_ac_name ?? this.user_ac_name,
      ifsc: ifsc ?? this.ifsc,
      num_of_game: num_of_game ?? this.num_of_game,
      language: language ?? this.language,
        bool_lang: bool_lang ?? this.bool_lang

    );
  }


}
