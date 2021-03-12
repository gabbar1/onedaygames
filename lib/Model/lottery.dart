class Lottery {
  String key;
  String amount;
  int announced;
  String deadline;
  String name;
  int numberofshell;
  int people;
  int price;
  String result_date;
  String start_date;
  int status;
  String ticket_id;
  String ticket_key;
  String ticket_type;
  String type;


  Lottery({this.type,this.key,this.amount,this.announced,this.deadline,this.name,this.numberofshell,this.people,this.price,this.result_date,this.start_date,this.status,this.ticket_id,this.ticket_key,this.ticket_type});
  Lottery.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    key = map["key"];
    amount = map["amount"].toString();
    announced = map["announced"];
    deadline = map["deadline"];
    name = map["name"];
    numberofshell = map["numberofsell"];
    people = map["people"];
    price = map["price"];
    result_date = map["result_date"];
    start_date = map["start_date"];
    status = map["status"];
    ticket_id = map["ticket_id"];
    ticket_key = map['ticket_key'].toString();
    ticket_type = map["ticket_type"];
    type = map["type"];
  }

  toJson() {
    return {
      'type':type,'key':	key,'amount':	amount,'announced':	announced,'deadline':	deadline,'name':	name,'numberofshell':	numberofshell,'people':	people,'price':	price,'result_date':	result_date,'start_date':	start_date,'status':	status,'ticket_id':	ticket_id,'ticket_key':	ticket_key,'ticket_type':	ticket_type,
    };
  }

  Lottery copyWith({String NumberId, String key,}) {
    return Lottery(key:	key	?? this.key	,
        amount:	amount	?? this.amount	,
        announced:	announced	?? this.announced	,
        deadline:	deadline	?? this.deadline	,
        name:	name	?? this.name	,
        numberofshell:	numberofshell	?? this.numberofshell	,
        people:	people	?? this.people	,
        price:	price	?? this.price	,
        result_date:	result_date	?? this.result_date	,
        start_date:	start_date	?? this.start_date	,
        status:	status	?? this.status	,
        ticket_id:	ticket_id	?? this.ticket_id	,
        ticket_key:	ticket_key	?? this.ticket_key	,
        ticket_type:	ticket_type	?? this.ticket_type	,
        type:	type	?? this.type	);
  }


}
