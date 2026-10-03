class ResumePersonalInfoModel {
  const ResumePersonalInfoModel({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.country = '',
    this.linkedinUrl = '',
    this.portfolioUrl = '',
    this.githubUrl = '',
  });

  final String fullName;
  final String email;
  final String phone;

  final String city;
  final String country;

  final String linkedinUrl;
  final String portfolioUrl;
  final String githubUrl;

  factory ResumePersonalInfoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const ResumePersonalInfoModel();
    }

    return ResumePersonalInfoModel(
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
      linkedinUrl: map['linkedinUrl'] as String? ?? '',
      portfolioUrl: map['portfolioUrl'] as String? ?? '',
      githubUrl: map['githubUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'country': country,
      'linkedinUrl': linkedinUrl,
      'portfolioUrl': portfolioUrl,
      'githubUrl': githubUrl,
    };
  }

  ResumePersonalInfoModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? city,
    String? country,
    String? linkedinUrl,
    String? portfolioUrl,
    String? githubUrl,
  }) {
    return ResumePersonalInfoModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      githubUrl: githubUrl ?? this.githubUrl,
    );
  }

  bool get isEmpty {
    return fullName.trim().isEmpty &&
        email.trim().isEmpty &&
        phone.trim().isEmpty &&
        city.trim().isEmpty &&
        country.trim().isEmpty &&
        linkedinUrl.trim().isEmpty &&
        portfolioUrl.trim().isEmpty &&
        githubUrl.trim().isEmpty;
  }
}
