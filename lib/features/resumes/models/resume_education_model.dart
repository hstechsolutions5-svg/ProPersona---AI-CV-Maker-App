import 'resume_model_utils.dart';

const Object _unsetEducation = Object();

class ResumeEducationModel {
  const ResumeEducationModel({
    required this.id,
    this.institution = '',
    this.degree = '',
    this.fieldOfStudy = '',
    this.location = '',
    this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.grade = '',
    this.description = '',
  });

  final String id;

  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String location;

  final DateTime? startDate;
  final DateTime? endDate;

  final bool isCurrent;

  final String grade;
  final String description;

  factory ResumeEducationModel.fromMap(Map<String, dynamic> map) {
    return ResumeEducationModel(
      id: map['id'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      degree: map['degree'] as String? ?? '',
      fieldOfStudy: map['fieldOfStudy'] as String? ?? '',
      location: map['location'] as String? ?? '',
      startDate: resumeDateFromValue(map['startDate']),
      endDate: resumeDateFromValue(map['endDate']),
      isCurrent: map['isCurrent'] as bool? ?? false,
      grade: map['grade'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'location': location,
      'startDate': resumeDateToFirestore(startDate),
      'endDate': resumeDateToFirestore(endDate),
      'isCurrent': isCurrent,
      'grade': grade,
      'description': description,
    };
  }

  ResumeEducationModel copyWith({
    String? institution,
    String? degree,
    String? fieldOfStudy,
    String? location,
    Object? startDate = _unsetEducation,
    Object? endDate = _unsetEducation,
    bool? isCurrent,
    String? grade,
    String? description,
  }) {
    return ResumeEducationModel(
      id: id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      location: location ?? this.location,
      startDate: identical(startDate, _unsetEducation)
          ? this.startDate
          : startDate as DateTime?,
      endDate: identical(endDate, _unsetEducation)
          ? this.endDate
          : endDate as DateTime?,
      isCurrent: isCurrent ?? this.isCurrent,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }

  bool get hasContent {
    return institution.trim().isNotEmpty ||
        degree.trim().isNotEmpty ||
        fieldOfStudy.trim().isNotEmpty;
  }
}
