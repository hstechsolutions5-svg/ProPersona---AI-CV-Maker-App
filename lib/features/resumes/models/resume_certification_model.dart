import 'resume_model_utils.dart';

const Object _unsetCertification = Object();

class ResumeCertificationModel {
  const ResumeCertificationModel({
    required this.id,
    this.name = '',
    this.issuer = '',
    this.issueDate,
    this.expiryDate,
    this.credentialId = '',
    this.credentialUrl = '',
  });

  final String id;

  final String name;
  final String issuer;

  final DateTime? issueDate;
  final DateTime? expiryDate;

  final String credentialId;
  final String credentialUrl;

  factory ResumeCertificationModel.fromMap(Map<String, dynamic> map) {
    return ResumeCertificationModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      issuer: map['issuer'] as String? ?? '',
      issueDate: resumeDateFromValue(map['issueDate']),
      expiryDate: resumeDateFromValue(map['expiryDate']),
      credentialId: map['credentialId'] as String? ?? '',
      credentialUrl: map['credentialUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'issueDate': resumeDateToFirestore(issueDate),
      'expiryDate': resumeDateToFirestore(expiryDate),
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
    };
  }

  ResumeCertificationModel copyWith({
    String? name,
    String? issuer,
    Object? issueDate = _unsetCertification,
    Object? expiryDate = _unsetCertification,
    String? credentialId,
    String? credentialUrl,
  }) {
    return ResumeCertificationModel(
      id: id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: identical(issueDate, _unsetCertification)
          ? this.issueDate
          : issueDate as DateTime?,
      expiryDate: identical(expiryDate, _unsetCertification)
          ? this.expiryDate
          : expiryDate as DateTime?,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }

  bool get hasContent {
    return name.trim().isNotEmpty || issuer.trim().isNotEmpty;
  }
}
