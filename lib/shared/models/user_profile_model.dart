import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/legal_document_versions.dart';
import 'career_stage.dart';
import 'subscription_model.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.subscriptionPlan,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.termsAcceptedAt,
    this.privacyAcceptedAt,
    this.photoUrl,
    this.careerStage,
  });

  final String uid;
  final String fullName;
  final String email;

  final String? photoUrl;

  final CareerStage? careerStage;

  final SubscriptionPlan subscriptionPlan;

  final bool onboardingCompleted;

  final String? acceptedTermsVersion;
  final String? acceptedPrivacyVersion;

  final DateTime? termsAcceptedAt;
  final DateTime? privacyAcceptedAt;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastLoginAt;

  // ─────────────────────────────────────────────
  // Factory — New User
  // ─────────────────────────────────────────────

  factory UserProfileModel.newUser({
    required String uid,
    required String fullName,
    required String email,
    String? photoUrl,
    required String acceptedTermsVersion,
    required String acceptedPrivacyVersion,
  }) {
    final now = DateTime.now().toUtc();

    return UserProfileModel(
      uid: uid,
      fullName: fullName.trim(),
      email: email.trim(),
      photoUrl: photoUrl,
      careerStage: null,
      subscriptionPlan: SubscriptionPlan.free,
      onboardingCompleted: false,
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
      acceptedTermsVersion: acceptedTermsVersion,
      acceptedPrivacyVersion: acceptedPrivacyVersion,
      termsAcceptedAt: now,
      privacyAcceptedAt: now,
    );
  }

  // ─────────────────────────────────────────────
  // Firestore
  // ─────────────────────────────────────────────

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      careerStage: CareerStage.fromString(map['careerStage'] as String?),
      subscriptionPlan: SubscriptionPlan.fromString(
        map['subscriptionPlan'] as String?,
      ),
      onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,

      acceptedTermsVersion: map['acceptedTermsVersion'] as String?,

      acceptedPrivacyVersion: map['acceptedPrivacyVersion'] as String?,

      termsAcceptedAt: _nullableDateFromFirestore(map['termsAcceptedAt']),

      privacyAcceptedAt: _nullableDateFromFirestore(map['privacyAcceptedAt']),

      createdAt: _dateFromFirestore(map['createdAt']),

      updatedAt: _dateFromFirestore(map['updatedAt']),

      lastLoginAt: _dateFromFirestore(map['lastLoginAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'careerStage': careerStage?.value,
      'subscriptionPlan': subscriptionPlan.value,
      'onboardingCompleted': onboardingCompleted,
      'acceptedTermsVersion': acceptedTermsVersion,

      'acceptedPrivacyVersion': acceptedPrivacyVersion,

      'termsAcceptedAt': termsAcceptedAt == null
          ? null
          : Timestamp.fromDate(termsAcceptedAt!),

      'privacyAcceptedAt': privacyAcceptedAt == null
          ? null
          : Timestamp.fromDate(privacyAcceptedAt!),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }

  // ─────────────────────────────────────────────
  // Copy
  // ─────────────────────────────────────────────

  UserProfileModel copyWith({
    String? fullName,
    String? email,
    String? photoUrl,
    CareerStage? careerStage,
    SubscriptionPlan? subscriptionPlan,
    bool? onboardingCompleted,
    String? acceptedTermsVersion,
    String? acceptedPrivacyVersion,
    DateTime? termsAcceptedAt,
    DateTime? privacyAcceptedAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserProfileModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      careerStage: careerStage ?? this.careerStage,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      acceptedTermsVersion: acceptedTermsVersion ?? this.acceptedTermsVersion,
      acceptedPrivacyVersion:
          acceptedPrivacyVersion ?? this.acceptedPrivacyVersion,
      termsAcceptedAt: termsAcceptedAt ?? this.termsAcceptedAt,
      privacyAcceptedAt: privacyAcceptedAt ?? this.privacyAcceptedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // ─────────────────────────────────────────────
  // Convenience
  // ─────────────────────────────────────────────

  bool get hasCareerStage => careerStage != null;

  bool get isGraduate => careerStage == CareerStage.graduate;

  bool get isProfessional => careerStage == CareerStage.professional;

  bool get isPremium => subscriptionPlan == SubscriptionPlan.premium;

  bool get hasAcceptedCurrentLegal {
    return acceptedTermsVersion == LegalDocumentVersions.terms &&
        acceptedPrivacyVersion == LegalDocumentVersions.privacy &&
        termsAcceptedAt != null &&
        privacyAcceptedAt != null;
  }

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  static DateTime _dateFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _nullableDateFromFirestore(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
