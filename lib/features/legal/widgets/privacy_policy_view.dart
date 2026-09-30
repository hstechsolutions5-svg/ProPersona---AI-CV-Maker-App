import 'package:flutter/material.dart';

import '../../../core/constants/legal_document_versions.dart';
import '../widgets/legal_document_view.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Privacy Policy',
      version: LegalDocumentVersions.privacy,
      effectiveDate: LegalDocumentVersions.effectiveDate,
      sections: [
        LegalSection(
          title: '1. Information We Collect',
          body:
              'ProPersona may collect account information such as your name, email address, authentication identifiers, career stage, resume information, document content, and information you choose to provide while using the service.',
        ),
        LegalSection(
          title: '2. How Information Is Used',
          body:
              'Information is used to authenticate users, provide ProPersona features, save career-document data, improve the user experience, maintain security, and support the operation of the service.',
        ),
        LegalSection(
          title: '3. Authentication and Cloud Data',
          body:
              'ProPersona uses Firebase Authentication for account authentication and Cloud Firestore for application data. Generated files may be created locally or on demand where supported by the product architecture.',
        ),
        LegalSection(
          title: '4. AI Processing',
          body:
              'When AI-powered features are used, selected resume, job-description, or career-related information may need to be processed by an AI service. ProPersona will provide appropriate disclosure and obtain any required additional consent before such processing where applicable.',
        ),
        LegalSection(
          title: '5. Sharing of Information',
          body:
              'Huzentra Technologies does not sell personal information. Information may be processed by service providers that are required to operate ProPersona, subject to their applicable terms, security measures, and privacy practices.',
        ),
        LegalSection(
          title: '6. Data Retention',
          body:
              'Information may be retained for as long as necessary to provide the service, maintain legitimate operational records, comply with applicable requirements, or resolve security and technical issues.',
        ),
        LegalSection(
          title: '7. Security',
          body:
              'Reasonable technical and organizational safeguards are used to protect ProPersona data. No online system can guarantee absolute security, and users should protect their credentials and devices.',
        ),
        LegalSection(
          title: '8. Your Choices',
          body:
              'Users may update applicable profile information and may contact Huzentra Technologies regarding privacy questions or requests relating to their information, subject to technical and legal limitations.',
        ),
        LegalSection(
          title: '9. Policy Updates',
          body:
              'This Privacy Policy may be revised as ProPersona evolves. Material updates may require renewed user consent before continued use of relevant services.',
        ),
        LegalSection(
          title: '10. Contact',
          body:
              'Privacy questions may be sent to huzentratechnologies@gmail.com. ProPersona is operated by Huzentra Technologies, Pakistan.',
        ),
      ],
    );
  }
}
