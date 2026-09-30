import 'package:flutter/material.dart';

import '../../../core/constants/legal_document_versions.dart';
import '../widgets/legal_document_view.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Terms & Conditions',
      version: LegalDocumentVersions.terms,
      effectiveDate: LegalDocumentVersions.effectiveDate,
      sections: [
        LegalSection(
          title: '1. Acceptance',
          body:
              'By creating or using a ProPersona account, you agree to these Terms & Conditions and the applicable Privacy Policy. If you do not agree, you should not create or use an account.',
        ),
        LegalSection(
          title: '2. ProPersona Service',
          body:
              'ProPersona is a digital career-document platform developed by Huzentra Technologies. It provides tools for creating, organizing, reviewing, and improving resumes, cover letters, and related career materials.',
        ),
        LegalSection(
          title: '3. Accounts and Security',
          body:
              'You are responsible for providing accurate account information and maintaining the security of your login credentials. You should notify Huzentra Technologies if you believe your account has been accessed without authorization.',
        ),
        LegalSection(
          title: '4. User Content',
          body:
              'You retain responsibility for information and documents you provide to ProPersona. You should only submit content that you are authorized to use and should review generated or edited career documents before relying on them.',
        ),
        LegalSection(
          title: '5. AI-Assisted Features',
          body:
              'Certain ProPersona features may use artificial intelligence to analyze or generate career-related content. AI output may contain inaccuracies and should be reviewed before use. Additional consent may be requested before personal information is processed by AI-powered features.',
        ),
        LegalSection(
          title: '6. Acceptable Use',
          body:
              'You may not misuse ProPersona, attempt unauthorized access, interfere with the service, submit unlawful content, impersonate another person, or use the platform in a way that violates applicable law or the rights of others.',
        ),
        LegalSection(
          title: '7. Availability',
          body:
              'Huzentra Technologies may update, modify, suspend, or improve ProPersona as the product evolves. Continuous or uninterrupted availability is not guaranteed.',
        ),
        LegalSection(
          title: '8. Responsibility',
          body:
              'ProPersona provides career-document tools and does not guarantee employment, interview selection, ATS acceptance, or any particular recruitment outcome.',
        ),
        LegalSection(
          title: '9. Changes to These Terms',
          body:
              'These Terms may be updated when the service, legal requirements, or product practices change. Where appropriate, users may be required to accept a newer version before continuing to use the service.',
        ),
        LegalSection(
          title: '10. Contact',
          body:
              'Questions regarding these Terms may be sent to huzentratechnologies@gmail.com. ProPersona is a product of Huzentra Technologies, Pakistan.',
        ),
      ],
    );
  }
}
