class AuthUserModel {
  const AuthUserModel({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;

  final String? displayName;
  final String? photoUrl;

  final bool emailVerified;

  bool get hasDisplayName => displayName?.trim().isNotEmpty ?? false;

  bool get hasPhoto => photoUrl?.trim().isNotEmpty ?? false;
}
