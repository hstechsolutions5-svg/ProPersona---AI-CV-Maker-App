import 'package:get/get.dart';
import 'package:pro_persona/features/resumes/controllers/resumes_controller.dart';

import '../../../shared/models/career_stage.dart';
import '../../authentication/models/session_state.dart';
import '../../authentication/services/session_service.dart';
import '../../resumes/models/resume_model.dart';

class DashboardController extends GetxController {
  DashboardController({
    required this._sessionService,
    required this._resumeController,
  });

  final SessionService _sessionService;
  final ResumeController _resumeController;

  Rx<SessionState> get sessionState => _sessionService.stateRx;

  RxList<ResumeModel> get resumeState => _resumeController.observableResumes;

  String get fullName {
    final name = _sessionService.profile?.fullName.trim();

    if (name == null || name.isEmpty) {
      return 'ProPersona User';
    }

    return name;
  }

  String get firstName {
    final name = fullName.trim();

    if (name.isEmpty) {
      return 'there';
    }

    return name.split(RegExp(r'\s+')).first;
  }

  CareerStage? get careerStage => _sessionService.profile?.careerStage;

  String get careerStageLabel {
    return switch (careerStage) {
      CareerStage.graduate => 'Student / Fresh Graduate',
      CareerStage.professional => 'Professional',
      null => 'Not selected',
    };
  }

  String get careerGuidance {
    return switch (careerStage) {
      CareerStage.graduate =>
        'Build a strong early-career profile by highlighting education, projects, internships, skills, and certifications.',
      CareerStage.professional =>
        'Strengthen your professional profile by emphasizing experience, measurable achievements, expertise, and career impact.',
      null =>
        'Complete your career profile to receive more personalized guidance.',
    };
  }

  String get careerTip {
    return switch (careerStage) {
      CareerStage.graduate =>
        'Highlight projects, internships, coursework, and practical skills that demonstrate your potential.',
      CareerStage.professional =>
        'Use measurable achievements and impact-focused bullet points whenever possible.',
      null => 'Keep your profile information up to date.',
    };
  }

  //
  // Phase 2.2 placeholders.
  //
  // These will become repository-backed values
  // during Resume and ATS implementation.
  //

  int get totalResumes => _resumeController.resumeCount;

  int get atsAnalyses => 0;

  int get coverLetters => 0;

  int get aiEnhancements => 0;
}
