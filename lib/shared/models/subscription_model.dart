enum SubscriptionPlan {
  free,
  premium;

  String get value => name;

  static SubscriptionPlan fromString(String? value) {
    return switch (value) {
      'premium' => SubscriptionPlan.premium,
      _ => SubscriptionPlan.free,
    };
  }
}
