class Member {
  final int id;
  final String name;
  final String firstName;
  final String fullName;
  final String tel;
  final String crowdNumber;
  bool presence;

  Member({
    required this.id,
    required this.name,
    required this.firstName,
    required this.fullName,
    required this.tel,
    required this.crowdNumber,
    required this.presence,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        name: json['name'],
        firstName: json['firstName'],
        fullName: json['fullName'],
        tel: json['tel'],
        crowdNumber: json['crowdNumber'],
        presence: json['presence'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'firstName': firstName,
        'fullName': fullName,
        'tel': tel,
        'crowdNumber': crowdNumber,
        'presence': presence,
      };
}
