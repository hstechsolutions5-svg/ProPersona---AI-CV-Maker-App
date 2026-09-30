enum CareerStage {
  graduate,
  professional;

  String get value => name;

  static CareerStage? fromString(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return switch (value) {
      'graduate' => CareerStage.graduate,
      'professional' => CareerStage.professional,
      _ => null,
    };
  }

  String get label {
    return switch (this) {
      CareerStage.graduate => 'Student / Fresh Graduate',

      CareerStage.professional => 'Professional',
    };
  }
}
