import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:real_estate_mvvm_app/data/datasources/local/property_database.dart';

class MockBox extends Mock implements Box {}

void main() {
  // Note: Testing Hive directly is tricky due to static methods.
  // In a real project, we'd use a wrapper for Hive static calls.
  // For now we verify the LocalPropertyDataSource can be instantiated cleanly.
  test('LocalPropertyDataSource can be instantiated', () {
    final dataSource = LocalPropertyDataSource();
    expect(dataSource, isNotNull);
  });
}
