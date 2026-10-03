import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? resumeDateFromValue(dynamic value) {
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

DateTime resumeRequiredDateFromValue(dynamic value) {
  return resumeDateFromValue(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

dynamic resumeDateToFirestore(DateTime? value) {
  if (value == null) {
    return null;
  }

  return Timestamp.fromDate(value);
}
