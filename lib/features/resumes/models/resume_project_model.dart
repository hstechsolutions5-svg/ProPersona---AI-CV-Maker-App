import 'resume_model_utils.dart';

const Object _unsetProject = Object();

class ResumeProjectModel {
  const ResumeProjectModel({
    required this.id,
    this.name = '',
    this.role = '',
    this.description = '',
    this.technologies = const <String>[],
    this.bullets = const <String>[],
    this.projectUrl = '',
    this.repositoryUrl = '',
    this.startDate,
    this.endDate,
  });

  final String id;

  final String name;
  final String role;

  final String description;

  final List<String> technologies;
  final List<String> bullets;

  final String projectUrl;
  final String repositoryUrl;

  final DateTime? startDate;
  final DateTime? endDate;

  factory ResumeProjectModel.fromMap(Map<String, dynamic> map) {
    return ResumeProjectModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? '',
      description: map['description'] as String? ?? '',
      technologies: List<String>.from(
        map['technologies'] as List<dynamic>? ?? const [],
      ),
      bullets: List<String>.from(map['bullets'] as List<dynamic>? ?? const []),
      projectUrl: map['projectUrl'] as String? ?? '',
      repositoryUrl: map['repositoryUrl'] as String? ?? '',
      startDate: resumeDateFromValue(map['startDate']),
      endDate: resumeDateFromValue(map['endDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'description': description,
      'technologies': technologies,
      'bullets': bullets,
      'projectUrl': projectUrl,
      'repositoryUrl': repositoryUrl,
      'startDate': resumeDateToFirestore(startDate),
      'endDate': resumeDateToFirestore(endDate),
    };
  }

  ResumeProjectModel copyWith({
    String? name,
    String? role,
    String? description,
    List<String>? technologies,
    List<String>? bullets,
    String? projectUrl,
    String? repositoryUrl,
    Object? startDate = _unsetProject,
    Object? endDate = _unsetProject,
  }) {
    return ResumeProjectModel(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      technologies: technologies ?? List<String>.from(this.technologies),
      bullets: bullets ?? List<String>.from(this.bullets),
      projectUrl: projectUrl ?? this.projectUrl,
      repositoryUrl: repositoryUrl ?? this.repositoryUrl,
      startDate: identical(startDate, _unsetProject)
          ? this.startDate
          : startDate as DateTime?,
      endDate: identical(endDate, _unsetProject)
          ? this.endDate
          : endDate as DateTime?,
    );
  }

  bool get hasContent {
    return name.trim().isNotEmpty ||
        description.trim().isNotEmpty ||
        bullets.any((bullet) => bullet.trim().isNotEmpty);
  }
}
