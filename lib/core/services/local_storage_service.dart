import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/local_storage_keys.dart';

class LocalStorageService extends GetxService {
  LocalStorageService({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  // ─────────────────────────────────────────────
  // Generic String
  // ─────────────────────────────────────────────

  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  // ─────────────────────────────────────────────
  // Generic Int
  // ─────────────────────────────────────────────

  Future<int?> getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<void> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  // ─────────────────────────────────────────────
  // Generic Bool
  // ─────────────────────────────────────────────

  Future<bool?> getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  // ─────────────────────────────────────────────
  // Remove
  // ─────────────────────────────────────────────

  Future<void> remove(String key) {
    return _preferences.remove(key);
  }

  // ─────────────────────────────────────────────
  // Theme
  // ─────────────────────────────────────────────

  Future<String?> getThemeMode() {
    return getString(LocalStorageKeys.themeMode);
  }

  Future<void> setThemeMode(String mode) {
    return setString(LocalStorageKeys.themeMode, mode);
  }

  // ─────────────────────────────────────────────
  // Last Opened Resume
  // ─────────────────────────────────────────────

  Future<String?> getLastOpenedResumeId() {
    return getString(LocalStorageKeys.lastOpenedResumeId);
  }

  Future<void> setLastOpenedResumeId(String resumeId) {
    return setString(LocalStorageKeys.lastOpenedResumeId, resumeId);
  }

  Future<void> clearLastOpenedResumeId() {
    return remove(LocalStorageKeys.lastOpenedResumeId);
  }

  // ─────────────────────────────────────────────
  // Dashboard Navigation
  // ─────────────────────────────────────────────

  Future<int> getDashboardSelectedIndex() async {
    return await getInt(LocalStorageKeys.dashboardSelectedIndex) ?? 0;
  }

  Future<void> setDashboardSelectedIndex(int index) {
    return setInt(LocalStorageKeys.dashboardSelectedIndex, index);
  }

  // ─────────────────────────────────────────────
  // Onboarding Tooltips
  // ─────────────────────────────────────────────

  Future<bool> getOnboardingTooltipsSeen() async {
    return await getBool(LocalStorageKeys.onboardingTooltipsSeen) ?? false;
  }

  Future<void> setOnboardingTooltipsSeen(bool value) {
    return setBool(LocalStorageKeys.onboardingTooltipsSeen, value);
  }

  // ─────────────────────────────────────────────
  // Resume Builder
  // ─────────────────────────────────────────────

  Future<int> getResumeBuilderLastStep() async {
    return await getInt(LocalStorageKeys.resumeBuilderLastStep) ?? 0;
  }

  Future<void> setResumeBuilderLastStep(int step) {
    return setInt(LocalStorageKeys.resumeBuilderLastStep, step);
  }

  // ─────────────────────────────────────────────
  // Clear ProPersona UI Preferences
  // ─────────────────────────────────────────────

  Future<void> clearAppPreferences() {
    return _preferences.clear(allowList: LocalStorageKeys.all);
  }
}
