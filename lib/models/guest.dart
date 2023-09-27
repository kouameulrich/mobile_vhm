class Guest {
  final String name;
  final String firstName;
  final String tel;
  final String inventorsName;
  //final String guestTel;
  //final String town;
  //final String quarter;
  final String gendle;
  final String registrationDate;
  //bool presence = false;

  Guest({
    required this.name,
    required this.firstName,
    required this.tel,
    required this.inventorsName,
    //required this.guestTel,
    //required this.town,
    //required this.quarter,
    required this.registrationDate,
    required this.gendle,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        name: json['name'],
        firstName: json['firstName'],
        tel: json['tel'],
        inventorsName: json['inventorsName'],
        //guestTel: json['guestTel'],
        //town: json['town'],
        //quarter: json['quarter'],
        registrationDate: json['registrationDate'],
        gendle: json['gendle'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'firstName': firstName,
        'tel': tel,
        'inventorsName': inventorsName,
        //'guestTel': guestTel,
        //'town': town,
        //'quarter': quarter,
        'registrationDate': registrationDate,
        'gendle': gendle,
      };
}
