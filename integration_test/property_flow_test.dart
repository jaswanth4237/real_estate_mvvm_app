import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:real_estate_mvvm_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full property flow tap on a card and view details', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Wait for the list to load (might need to mock the API or wait for actual data)
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final propertyCard = find.byType(InkWell).first;
    expect(propertyCard, findsOneWidget);

    await tester.tap(propertyCard);
    await tester.pumpAndSettle();

    expect(find.text('Property Details'), findsOneWidget);
  });
}
