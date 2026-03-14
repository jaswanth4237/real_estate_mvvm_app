import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/feature_flags/feature_flag_service.dart';

void main() {
  late FeatureFlagService service;

  setUp(() {
    service = FeatureFlagService();
    // No init() call here because it uses rootBundle which fails in unit tests
  });

  test('isEnabled returns false when not initialized', () {
    final enabled = service.isEnabled('any_flag');
    expect(enabled, false);
  });
}
