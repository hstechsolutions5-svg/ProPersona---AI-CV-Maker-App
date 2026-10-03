import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../resumes/models/resume_personal_info_model.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({
    required this.personalInfo,
    required this.onChanged,
    super.key,
  });

  final ResumePersonalInfoModel personalInfo;

  final ValueChanged<ResumePersonalInfoModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 620;

        final width = twoColumns
            ? (constraints.maxWidth - AppSpacing.md) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _field(
              width,
              'Full Name',
              personalInfo.fullName,
              Icons.person_outline,
              (value) => onChanged(personalInfo.copyWith(fullName: value)),
            ),
            _field(
              width,
              'Email',
              personalInfo.email,
              Icons.email_outlined,
              (value) => onChanged(personalInfo.copyWith(email: value)),
              keyboardType: TextInputType.emailAddress,
            ),
            _field(
              width,
              'Phone',
              personalInfo.phone,
              Icons.phone_outlined,
              (value) => onChanged(personalInfo.copyWith(phone: value)),
              keyboardType: TextInputType.phone,
            ),
            _field(
              width,
              'City',
              personalInfo.city,
              Icons.location_city_outlined,
              (value) => onChanged(personalInfo.copyWith(city: value)),
            ),
            _field(
              width,
              'Country',
              personalInfo.country,
              Icons.public_outlined,
              (value) => onChanged(personalInfo.copyWith(country: value)),
            ),
            _field(
              width,
              'LinkedIn URL',
              personalInfo.linkedinUrl,
              Icons.link_rounded,
              (value) => onChanged(personalInfo.copyWith(linkedinUrl: value)),
            ),
            _field(
              width,
              'Portfolio URL',
              personalInfo.portfolioUrl,
              Icons.language_outlined,
              (value) => onChanged(personalInfo.copyWith(portfolioUrl: value)),
            ),
            _field(
              width,
              'GitHub URL',
              personalInfo.githubUrl,
              Icons.code_rounded,
              (value) => onChanged(personalInfo.copyWith(githubUrl: value)),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    double width,
    String label,
    String initialValue,
    IconData icon,
    ValueChanged<String> onChanged, {
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        onChanged: onChanged,
      ),
    );
  }
}
