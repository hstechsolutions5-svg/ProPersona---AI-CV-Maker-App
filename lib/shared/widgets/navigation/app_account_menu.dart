import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../features/authentication/controllers/authentication_controller.dart';
import '../../../features/authentication/services/session_service.dart';

enum _AccountAction { profile, settings, subscription, logout }

class AppAccountMenu extends StatelessWidget {
  const AppAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionService>();

    return Obx(() {
      final profile = session.profile;

      final initials = profile?.initials ?? 'P';

      final displayName = profile?.fullName ?? 'ProPersona User';

      final email = profile?.email ?? '';

      return PopupMenuButton<_AccountAction>(
        tooltip: 'Account',
        onSelected: (action) {
          unawaited(_handleAction(action));
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem<_AccountAction>(
              enabled: false,
              child: SizedBox(
                width: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const PopupMenuDivider(),

            const PopupMenuItem<_AccountAction>(
              value: _AccountAction.profile,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline_rounded),
                title: Text('Profile'),
              ),
            ),

            const PopupMenuItem<_AccountAction>(
              value: _AccountAction.settings,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.settings_outlined),
                title: Text('Settings'),
              ),
            ),

            const PopupMenuItem<_AccountAction>(
              value: _AccountAction.subscription,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.workspace_premium_outlined),
                title: Text('Subscription'),
              ),
            ),

            const PopupMenuDivider(),

            const PopupMenuItem<_AccountAction>(
              value: _AccountAction.logout,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.logout_rounded),
                title: Text('Sign Out'),
              ),
            ),
          ];
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: CircleAvatar(
            radius: 18,
            child: Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _handleAction(_AccountAction action) async {
    switch (action) {
      case _AccountAction.profile:
        Get.offAllNamed(AppRoutes.profile);
        return;

      case _AccountAction.settings:
        Get.offAllNamed(AppRoutes.settings);
        return;

      case _AccountAction.subscription:
        Get.offAllNamed(AppRoutes.subscription);
        return;

      case _AccountAction.logout:
        final controller = Get.find<AuthController>();

        final success = await controller.logout();

        if (success) {
          Get.offAllNamed(AppRoutes.splash);
        }

        return;
    }
  }
}
