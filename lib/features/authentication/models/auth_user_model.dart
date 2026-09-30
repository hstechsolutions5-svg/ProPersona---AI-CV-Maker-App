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

  bool get hasDisplayName {
    return displayName != null && displayName!.trim().isNotEmpty;
  }

  bool get hasPhoto {
    return photoUrl != null && photoUrl!.trim().isNotEmpty;
  }

  @override
  String toString() {
    return 'AuthUserModel('
        'uid: $uid, '
        'email: $email, '
        'displayName: $displayName, '
        'emailVerified: $emailVerified'
        ')';
  }
}
