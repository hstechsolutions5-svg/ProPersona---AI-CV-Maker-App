import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resumes/models/resume_certification_model.dart';
import '../../resumes/models/resume_education_model.dart';
import '../../resumes/models/resume_experience_model.dart';
import '../../resumes/models/resume_model.dart';
import '../../resumes/models/resume_project_model.dart';
import '../../resumes/models/resume_section_type.dart';
import 'resume_preview_section.dart';

class AtsResumePreview
    extends StatelessWidget {
  const AtsResumePreview({
    required this.resume,
    super.key,
  });

  final ResumeModel resume;

  static const Color _textColor =
  Color(0xFF18202E);

  static const Color _mutedColor =
  Color(0xFF667085);

  static const Color _primary =
  Color(0xFF24348F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 794,
      constraints: const BoxConstraints(
        minHeight: 1123,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 54,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 8),
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: _textColor,
          fontSize: 12,
          height: 1.45,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 24),

            for (final section
            in resume.sectionOrder)
              if (resume.isSectionEnabled(
                section,
              ))
                _buildSection(section),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final info =
        resume.personalInfo;

    final fullName =
    info.fullName.trim().isEmpty
        ? 'Your Name'
        : info.fullName.trim();

    final contactItems =
    <String>[
      info.email.trim(),
      info.phone.trim(),
      _locationText(),
      info.linkedinUrl.trim(),
      info.portfolioUrl.trim(),
      info.githubUrl.trim(),
    ].where(
          (item) => item.isNotEmpty,
    ).toList();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: const TextStyle(
            color: _primary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),

        if (resume.hasTargetRole) ...[
          const SizedBox(height: 5),

          Text(
            resume.targetRole!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _mutedColor,
            ),
          ),
        ],

        if (contactItems.isNotEmpty) ...[
          const SizedBox(height: 12),

          Wrap(
            spacing: 7,
            runSpacing: 4,
            children: [
              for (var index = 0;
              index < contactItems.length;
              index++) ...[
                Text(
                  contactItems[index],
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: _mutedColor,
                  ),
                ),

                if (index !=
                    contactItems.length - 1)
                  const Text(
                    '•',
                    style: TextStyle(
                      color: _mutedColor,
                    ),
                  ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSection(
      ResumeSectionType section,
      ) {
    return switch (section) {
      ResumeSectionType.personalInfo =>
      const SizedBox.shrink(),

      ResumeSectionType.professionalSummary =>
          _buildSummary(),

      ResumeSectionType.education =>
          _buildEducation(),

      ResumeSectionType.experience =>
          _buildExperience(),

      ResumeSectionType.projects =>
          _buildProjects(),

      ResumeSectionType.skills =>
          _buildSkills(),

      ResumeSectionType.certifications =>
          _buildCertifications(),
    };
  }

  Widget _buildSummary() {
    final summary =
    resume.professionalSummary.trim();

    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Professional Summary',
      child: Text(summary),
    );
  }

  Widget _buildEducation() {
    final items = resume.education
        .where(
          (item) => item.hasContent,
    )
        .toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Education',
      child: Column(
        children: [
          for (var index = 0;
          index < items.length;
          index++) ...[
            _EducationPreview(
              item: items[index],
            ),

            if (index != items.length - 1)
              const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildExperience() {
    final items = resume.experience
        .where(
          (item) => item.hasContent,
    )
        .toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Experience',
      child: Column(
        children: [
          for (var index = 0;
          index < items.length;
          index++) ...[
            _ExperiencePreview(
              item: items[index],
            ),

            if (index != items.length - 1)
              const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildProjects() {
    final items = resume.projects
        .where(
          (item) => item.hasContent,
    )
        .toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Projects',
      child: Column(
        children: [
          for (var index = 0;
          index < items.length;
          index++) ...[
            _ProjectPreview(
              item: items[index],
            ),

            if (index != items.length - 1)
              const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSkills() {
    final skills = resume.skills
        .map((skill) => skill.trim())
        .where(
          (skill) => skill.isNotEmpty,
    )
        .toList();

    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Skills',
      child: Text(
        skills.join(' • '),
      ),
    );
  }

  Widget _buildCertifications() {
    final items =
    resume.certifications
        .where(
          (item) =>
      item.hasContent,
    )
        .toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResumePreviewSection(
      title: 'Certifications',
      child: Column(
        children: [
          for (var index = 0;
          index < items.length;
          index++) ...[
            _CertificationPreview(
              item: items[index],
            ),

            if (index != items.length - 1)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  String _locationText() {
    final city =
    resume.personalInfo.city.trim();

    final country =
    resume.personalInfo.country.trim();

    if (city.isNotEmpty &&
        country.isNotEmpty) {
      return '$city, $country';
    }

    return city.isNotEmpty
        ? city
        : country;
  }
}

class _EducationPreview
    extends StatelessWidget {
  const _EducationPreview({
    required this.item,
  });

  final ResumeEducationModel item;

  @override
  Widget build(BuildContext context) {
    final title = [
      item.degree.trim(),
      item.fieldOfStudy.trim(),
    ].where(
          (value) => value.isNotEmpty,
    ).join(' in ');

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _TitleAndDateRow(
          title: title.isEmpty
              ? item.institution
              : title,
          dateText: _dateRange(
            item.startDate,
            item.endDate,
            item.isCurrent,
          ),
        ),

        if (item.institution
            .trim()
            .isNotEmpty)
          Text(
            item.institution.trim(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

        if (item.location
            .trim()
            .isNotEmpty)
          Text(
            item.location.trim(),
            style: const TextStyle(
              color: AtsResumePreview
                  ._mutedColor,
              fontSize: 10.5,
            ),
          ),

        if (item.grade
            .trim()
            .isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            'Grade: ${item.grade.trim()}',
          ),
        ],

        if (item.description
            .trim()
            .isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            item.description.trim(),
          ),
        ],
      ],
    );
  }
}

class _ExperiencePreview
    extends StatelessWidget {
  const _ExperiencePreview({
    required this.item,
  });

  final ResumeExperienceModel item;

  @override
  Widget build(BuildContext context) {
    final bullets = item.bullets
        .map((item) => item.trim())
        .where(
          (item) => item.isNotEmpty,
    )
        .toList();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _TitleAndDateRow(
          title: item.jobTitle
              .trim()
              .isEmpty
              ? item.company.trim()
              : item.jobTitle.trim(),
          dateText: _dateRange(
            item.startDate,
            item.endDate,
            item.isCurrent,
          ),
        ),

        if (item.company
            .trim()
            .isNotEmpty)
          Text(
            item.company.trim(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

        if (item.location
            .trim()
            .isNotEmpty)
          Text(
            item.location.trim(),
            style: const TextStyle(
              color: AtsResumePreview
                  ._mutedColor,
              fontSize: 10.5,
            ),
          ),

        if (bullets.isNotEmpty) ...[
          const SizedBox(height: 6),

          for (final bullet in bullets)
            _BulletText(
              text: bullet,
            ),
        ],
      ],
    );
  }
}

class _ProjectPreview
    extends StatelessWidget {
  const _ProjectPreview({
    required this.item,
  });

  final ResumeProjectModel item;

  @override
  Widget build(BuildContext context) {
    final technologies =
    item.technologies
        .map(
          (item) =>
          item.trim(),
    )
        .where(
          (item) =>
      item.isNotEmpty,
    )
        .toList();

    final bullets =
    item.bullets
        .map(
          (item) =>
          item.trim(),
    )
        .where(
          (item) =>
      item.isNotEmpty,
    )
        .toList();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _TitleAndDateRow(
          title:
          item.name.trim(),
          dateText:
          _dateRange(
            item.startDate,
            item.endDate,
            false,
          ),
        ),

        if (item.role
            .trim()
            .isNotEmpty)
          Text(
            item.role.trim(),
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),

        if (item.description
            .trim()
            .isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            item.description.trim(),
          ),
        ],

        if (technologies
            .isNotEmpty) ...[
          const SizedBox(height: 5),

          Text(
            'Technologies: ${technologies.join(', ')}',
            style: const TextStyle(
              fontSize: 10.5,
            ),
          ),
        ],

        if (item.projectUrl
            .trim()
            .isNotEmpty) ...[
          const SizedBox(height: 4),

          Text(
            item.projectUrl.trim(),
            style: const TextStyle(
              fontSize: 10.5,
              color:
              AtsResumePreview
                  ._mutedColor,
            ),
          ),
        ],

        if (item.repositoryUrl
            .trim()
            .isNotEmpty)
          Text(
            item.repositoryUrl.trim(),
            style: const TextStyle(
              fontSize: 10.5,
              color:
              AtsResumePreview
                  ._mutedColor,
            ),
          ),

        if (bullets.isNotEmpty) ...[
          const SizedBox(height: 6),

          for (final bullet in bullets)
            _BulletText(
              text: bullet,
            ),
        ],
      ],
    );
  }
}

class _CertificationPreview
    extends StatelessWidget {
  const _CertificationPreview({
    required this.item,
  });

  final ResumeCertificationModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _TitleAndDateRow(
          title:
          item.name.trim(),
          dateText:
          _certificationDate(
            item.issueDate,
            item.expiryDate,
          ),
        ),

        if (item.issuer
            .trim()
            .isNotEmpty)
          Text(
            item.issuer.trim(),
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),

        if (item.credentialId
            .trim()
            .isNotEmpty) ...[
          const SizedBox(height: 3),

          Text(
            'Credential ID: ${item.credentialId.trim()}',
            style: const TextStyle(
              fontSize: 10.5,
            ),
          ),
        ],

        if (item.credentialUrl
            .trim()
            .isNotEmpty)
          Text(
            item.credentialUrl.trim(),
            style: const TextStyle(
              fontSize: 10.5,
              color:
              AtsResumePreview
                  ._mutedColor,
            ),
          ),
      ],
    );
  }
}

class _TitleAndDateRow
    extends StatelessWidget {
  const _TitleAndDateRow({
    required this.title,
    required this.dateText,
  });

  final String title;
  final String dateText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight:
              FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),

        if (dateText.isNotEmpty) ...[
          const SizedBox(width: 12),

          Text(
            dateText,
            style: const TextStyle(
              color:
              AtsResumePreview
                  ._mutedColor,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }
}

class _BulletText
    extends StatelessWidget {
  const _BulletText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 3,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
            EdgeInsets.only(
              top: 1,
            ),
            child: Text('•'),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

String _dateRange(
    DateTime? start,
    DateTime? end,
    bool isCurrent,
    ) {
  final startText =
  _formatMonthYear(start);

  final endText = isCurrent
      ? 'Present'
      : _formatMonthYear(end);

  if (startText.isEmpty &&
      endText.isEmpty) {
    return '';
  }

  if (startText.isEmpty) {
    return endText;
  }

  if (endText.isEmpty) {
    return startText;
  }

  return '$startText – $endText';
}

String _certificationDate(
    DateTime? issue,
    DateTime? expiry,
    ) {
  final issueText =
  _formatMonthYear(issue);

  final expiryText =
  _formatMonthYear(expiry);

  if (issueText.isEmpty &&
      expiryText.isEmpty) {
    return '';
  }

  if (expiryText.isEmpty) {
    return issueText;
  }

  if (issueText.isEmpty) {
    return 'Expires $expiryText';
  }

  return '$issueText – $expiryText';
}

String _formatMonthYear(
    DateTime? value,
    ) {
  if (value == null) {
    return '';
  }

  return DateFormat(
    'MMM yyyy',
  ).format(
    value.toLocal(),
  );
}