class GuestPost {
  //final int memberId;
  final String memberLastName;
  final String memberFirstName;
  //final String memberFullName;
  final String memberPhone;
  final String memberDateOfEntry;
  final String memberInvitedBy;
  //final String memberInvitedByPhone;
  //final String memberImage;
  //final String memberEmail;
  //final String memberDateOfBirth;
  //final String memberDateOfBaptism;
  //final String memberCountry;
  //final String memberCity;
  //final String memberTownship;
  //final String memberQuarter;
  //final String memberBatizedStatus;
  final String memberGender;
  final int churchId;
  final int memberTypeId;
  //final int ministerialResponsibilityId;
  //final int memberMaritalStatusId;
  //final Object memberMaritalStatus;
  //final Object memberType;
  //final Object church;
  //final Object ministerialResponsibility;
  //bool flag;

  GuestPost({
    //required this.memberId,
    required this.memberLastName,
    required this.memberFirstName,
    //required this.memberFullName,
    required this.memberPhone,
    required this.memberDateOfEntry,
    required this.memberInvitedBy,
    //final String memberInvitedByPhone,
    //required this.memberImage,
    //required this.memberEmail,
    //required this.memberDateOfBirth,
    //required this.memberDateOfBaptism,
    //required this.memberCountry,
    //required this.memberCity,
    //required this.memberTownship,
    //required this.memberQuarter,
    //required this.memberMaritalStatus,
    required this.memberGender,
    required this.churchId,
    required this.memberTypeId,
    //required this.ministerialResponsibilityId,
    //required this.memberMaritalStatusId,
    //required this.memberBatizedStatus,
    //required this.memberType,
    //required this.church,
    //required this.ministerialResponsibility,
    //required this.flag,
  });

  factory GuestPost.fromJson(Map<String, dynamic> json) => GuestPost(
        //memberId: json['memberId'],
        memberLastName: json['memberLastName'],
        memberFirstName: json['memberFirstName'],
        //memberFullName: json['memberFullName'],
        memberPhone: json['memberPhone'],
        memberDateOfEntry: json['memberDateOfEntry'],
        memberInvitedBy: json['memberInvitedBy'],
        //memberImage: json['memberImage'],
        //memberEmail: json['memberEmail'],
        //memberDateOfBirth: json['memberDateOfBirth'],
        //memberDateOfBaptism: json['memberDateOfBaptism'],
        //memberCountry: json['memberCountry'],
        //memberCity: json['memberCity'],
        //memberTownship: json['memberTownship'],
        //memberQuarter: json['memberQuarter'],
        //memberMaritalStatus: json['memberMaritalStatus'],
        memberGender: json['memberGender'],
        churchId: json['churchId'],
        memberTypeId: json['memberTypeId'],
        //ministerialResponsibilityId: json['ministerialResponsibilityId'],
        //memberMaritalStatusId: json['memberMaritalStatusId'],
        //memberBatizedStatus: json['memberBatizedStatus'],
        //memberType: json['memberType'],
        //church: json['church'],
        //ministerialResponsibility: json['ministerialResponsibility'],
        //flag: json['flag'],
      );

  Map<String, dynamic> toJson() => {
        //'memberId': memberId,
        'memberLastName': memberLastName,
        'memberFirstName': memberFirstName,
        //'memberFullName': memberFullName,
        'memberPhone': memberPhone,
        'memberDateOfEntry': memberDateOfEntry,
        'memberInvitedBy': memberInvitedBy,
        //'memberImage': memberImage,
        //'memberEmail': memberEmail,
        //'memberDateOfBirth': memberDateOfBirth,
        //'memberDateOfBaptism': memberDateOfBaptism,
        //'memberCountry': memberCountry,
        //'memberCity': memberCity,
        //'memberTownship': memberTownship,
        //'memberQuarter': memberQuarter,
        //'memberMaritalStatus': memberMaritalStatus,
        'memberGender': memberGender,
        'churchId': churchId,
        'memberTypeId': memberTypeId,
        //'ministerialResponsibilityId': ministerialResponsibilityId,
        //'memberMaritalStatusId': memberMaritalStatusId,
        //'memberBatizedStatus': memberBatizedStatus,
        //'memberType': memberType,
        //'church': church,
        //'ministerialResponsibility': ministerialResponsibility,
        //'flag': flag
      };
}
