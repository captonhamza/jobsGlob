class CompanyProfileModel {
  final bool? error;
  final String? message;
  final CompanyProfileData? data;

  CompanyProfileModel({
    this.error,
    this.message,
    this.data,
  });

  CompanyProfileModel.fromJson(Map<String, dynamic> json)
      : error = json['error'] as bool?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? CompanyProfileData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'error': error, 'message': message, 'data': data?.toJson()};
}

class CompanyProfileData {
  final int? id;
  final int? userId;
  final String? companyLogo;
  final String? companyName;
  final String? mail;
  final String? phone;
  final String? website;
  final String? teamSize;
  final String? aboutCompany;
  final String? address;
  final int? status;
  final String? city;
  final String? country;

  CompanyProfileData({
    this.id,
    this.userId,
    this.companyLogo,
    this.companyName,
    this.mail,
    this.phone,
    this.website,
    this.teamSize,
    this.aboutCompany,
    this.address,
    this.status,
    this.city,
    this.country,
  });

  CompanyProfileData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        companyLogo = json['company_logo'] as String?,
        companyName = json['company_name'] as String?,
        mail = json['mail'] as String?,
        phone = json['phone'] as String?,
        website = json['website'] as String?,
        teamSize = json['team_size'] as String?,
        aboutCompany = json['about_company'] as String?,
        address = json['address'] as String?,
        status = json['status'] as int?,
        city = json['city'] as String?,
        country = json['country'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'company_logo': companyLogo,
        'company_name': companyName,
        'mail': mail,
        'phone': phone,
        'website': website,
        'team_size': teamSize,
        'about_company': aboutCompany,
        'address': address,
        'status': status,
        'city': city,
        'country': country
      };
}
