class CandidatePRofileModel {
  final bool? error;
  final String? message;
  final CandidateProfileData? data;

  CandidatePRofileModel({
    this.error,
    this.message,
    this.data,
  });

  CandidatePRofileModel.fromJson(Map<String, dynamic> json)
      : error = json['error'] as bool?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? CandidateProfileData.fromJson(
                json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'error': error, 'message': message, 'data': data?.toJson()};
}

class CandidateProfileData {
  final int? id;
  final int? userId;
  final String? category;
  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? birthDate;
  final String? address;
  final String? town;
  final String? postCode;
  final String? email;
  final String? phone;
  final String? nationality;
  final String? insuranceNo;
  final String? eContactName;
  final String? eContactRelation;
  final String? eContactPhone;
  final String? badgeType;
  final String? badgeNumber;
  final String? badgeExpiry;
  final String? bankSortCode;
  final String? accountNumber;
  final String? nameOfAccount;
  final String? utrNumber;
  final int? visaRequired;
  final int? ukDrivingLicence;
  final int? status;
  final String? birthCity;
  final String? country;
  final String? profilePic;
  final String? filePortfolioVideo;
  final String? fileResume;
  final String? passportPic;
  final String? utilitybillPic;
  final String? residentPic;
  final String? badgePic;

  CandidateProfileData({
    this.id,
    this.userId,
    this.category,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.address,
    this.town,
    this.postCode,
    this.email,
    this.phone,
    this.nationality,
    this.insuranceNo,
    this.eContactName,
    this.eContactRelation,
    this.eContactPhone,
    this.badgeType,
    this.badgeNumber,
    this.badgeExpiry,
    this.bankSortCode,
    this.accountNumber,
    this.nameOfAccount,
    this.utrNumber,
    this.visaRequired,
    this.ukDrivingLicence,
    this.status,
    this.birthCity,
    this.country,
    this.profilePic,
    this.filePortfolioVideo,
    this.fileResume,
    this.passportPic,
    this.utilitybillPic,
    this.residentPic,
    this.badgePic,
  });

  CandidateProfileData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        category = json['category'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        gender = json['gender'] as int?,
        birthDate = json['birth_date'] as String?,
        address = json['address'] as String?,
        town = json['town'] as String?,
        postCode = json['post_code'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        nationality = json['nationality'] as String?,
        insuranceNo = json['insurance_no'] as String?,
        eContactName = json['e_contact_name'] as String?,
        eContactRelation = json['e_contact_relation'] as String?,
        eContactPhone = json['e_contact_phone'] as String?,
        badgeType = json['badge_type'] as String?,
        badgeNumber = json['badge_number'] as String?,
        badgeExpiry = json['badge_expiry'] as String?,
        bankSortCode = json['bank_sort_code'] as String?,
        accountNumber = json['account_number'] as String?,
        nameOfAccount = json['name_of_account'] as String?,
        utrNumber = json['utr_number'] as String?,
        visaRequired = json['visa_required'] as int?,
        ukDrivingLicence = json['uk_driving_licence'] as int?,
        status = json['status'] as int?,
        birthCity = json['birth_city'] as String?,
        country = json['country'] as String?,
        profilePic = json['profile_pic'] as String?,
        filePortfolioVideo = json['file_portfolio_video'] as String?,
        fileResume = json['file_resume'] as String?,
        passportPic = json['passport_pic'] as String?,
        utilitybillPic = json['utilitybill_pic'] as String?,
        residentPic = json['resident_pic'] as String?,
        badgePic = json['badge_pic'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'category': category,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'birth_date': birthDate,
        'address': address,
        'town': town,
        'post_code': postCode,
        'email': email,
        'phone': phone,
        'nationality': nationality,
        'insurance_no': insuranceNo,
        'e_contact_name': eContactName,
        'e_contact_relation': eContactRelation,
        'e_contact_phone': eContactPhone,
        'badge_type': badgeType,
        'badge_number': badgeNumber,
        'badge_expiry': badgeExpiry,
        'bank_sort_code': bankSortCode,
        'account_number': accountNumber,
        'name_of_account': nameOfAccount,
        'utr_number': utrNumber,
        'visa_required': visaRequired,
        'uk_driving_licence': ukDrivingLicence,
        'status': status,
        'birth_city': birthCity,
        'country': country,
        'profile_pic': profilePic,
        'file_portfolio_video': filePortfolioVideo,
        'file_resume': fileResume,
        'passport_pic': passportPic,
        'utilitybill_pic': utilitybillPic,
        'resident_pic': residentPic,
        'badge_pic': badgePic
      };
}
