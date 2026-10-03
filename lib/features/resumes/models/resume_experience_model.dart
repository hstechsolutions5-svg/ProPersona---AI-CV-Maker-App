import 'resume_model_utils.dart';

const Object _unsetExperience = Object();

class ResumeExperienceModel {
  const ResumeExperienceModel({
    required this.id,
    this.company = '',
    this.jobTitle = '',
    this.location = '',
    this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.bullets = const <String>[],
  });

  final String id;

  final String company;
  final String jobTitle;
  final String location;

  final DateTime? startDate;
  final DateTime? endDate;

  final bool isCurrent;

  final List<String> bullets;

  factory ResumeExperienceModel.fromMap(Map<String, dynamic> map) {
    return ResumeExperienceModel(
      id: map['id'] as String? ?? '',
      company: map['company'] as String? ?? '',
      jobTitle: map['jobTitle'] as String? ?? '',
      location: map['location'] as String? ?? '',
      startDate: resumeDateFromValue(map['startDate']),
      endDate: resumeDateFromValue(map['endDate']),
      isCurrent: map['isCurrent'] as bool? ?? false,
      bullets: List<String>.from(map['bullets'] as List<dynamic>? ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'jobTitle': jobTitle,
      'location': location,
      'startDate': resumeDateToFirestore(startDate),
      'endDate': resumeDateToFirestore(endDate),
      'isCurrent': isCurrent,
      'bullets': bullets,
    };
  }

  ResumeExperienceModel copyWith({
    String? company,
    String? jobTitle,
    String? location,
    Object? startDate = _unsetExperience,
    Object? endDate = _unsetExperience,
    bool? isCurrent,
    List<String>? bullets,
  }) {
    return ResumeExperienceModel(
      id: id,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      location: location ?? this.location,
      startDate: identical(startDate, _unsetExperience)
          ? this.startDate
          : startDate as DateTime?,
      endDate: identical(endDate, _unsetExperience)
          ? this.endDate
          : endDate as DateTime?,
      isCurrent: isCurrent ?? this.isCurrent,
      bullets: bullets ?? List<String>.from(this.bullets),
    );
  }

  bool get hasContent {
    return company.trim().isNotEmpty ||
        jobTitle.trim().isNotEmpty ||
        bullets.any((bullet) => bullet.trim().isNotEmpty);
  }
}
