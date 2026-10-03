import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/navigation/app_page_container.dart';
import '../../../shared/widgets/navigation/app_shell.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_ats_card.dart';
import '../widgets/dashboard_career_stage_card.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/dashboard_quick_actions_card.dart';
import '../widgets/dashboard_recent_resumes_card.dart';
import '../widgets/dashboard_welcome_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Establish reactive dependency on
      // SessionService state.
      controller.sessionState.value;

      return AppShell(
        title: 'Dashboard',
        currentRoute: AppRoutes.dashboard,
        child: AppPageContainer(
          child: ResponsiveBuilder(
            builder: (context, deviceType, constraints) {
              final columns = switch (deviceType) {
                DeviceType.mobile => 1,
                DeviceType.tablet => 2,
                DeviceType.desktop => 4,
              };

              final wideSpan = columns == 4 ? 2 : 1;

              return SingleChildScrollView(
                child: StaggeredGrid.count(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  children: [
                    StaggeredGridTile.fit(
                      crossAxisCellCount: columns,
                      child: DashboardWelcomeCard(
                        firstName: controller.firstName,
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: DashboardMetricCard(
                        title: 'Total Resumes',
                        value: controller.totalResumes.toString(),
                        icon: Icons.description_outlined,
                        description: 'Create your first resume',
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: DashboardMetricCard(
                        title: 'ATS Analyses',
                        value: controller.atsAnalyses.toString(),
                        icon: Icons.analytics_outlined,
                        description: 'No analysis yet',
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: DashboardMetricCard(
                        title: 'Cover Letters',
                        value: controller.coverLetters.toString(),
                        icon: Icons.mail_outline,
                        description: 'No letters generated',
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: DashboardMetricCard(
                        title: 'AI Enhancements',
                        value: controller.aiEnhancements.toString(),
                        icon: Icons.auto_awesome_outlined,
                        description: 'AI tools ready when you are',
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: wideSpan,
                      child: const DashboardAtsCard(),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: wideSpan,
                      child: const DashboardRecentResumesCard(),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: wideSpan,
                      child: DashboardCareerStageCard(
                        label: controller.careerStageLabel,
                        guidance: controller.careerGuidance,
                        tip: controller.careerTip,
                      ),
                    ),

                    StaggeredGridTile.fit(
                      crossAxisCellCount: wideSpan,
                      child: const DashboardQuickActionsCard(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
