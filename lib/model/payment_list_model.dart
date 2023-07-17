class Payment_list {
  String name;
  String phone_no;
  String ref_id;
  String creation_date;
  String amount;

  Payment_list(
      {required this.name,
      required this.phone_no,
      required this.ref_id,
      required this.creation_date,
      required this.amount});
  factory Payment_list.fromJson(Map<String, dynamic> json) {
    return Payment_list(
        name: json['Name'],
        phone_no: json["Phone No"],
        ref_id: json["Ref ID"],
        creation_date: json['Creation Date'],
        amount: json['Amount']);
  }
}
