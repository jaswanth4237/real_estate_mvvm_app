import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/presentation/widgets/property_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  final tProperty = PropertyModel(
    propertyId: 1,
    title: 'Modern Villa',
    description: 'Beautiful villa with pool',
    price: 250000,
    bedrooms: 4,
    imageUrl: 'http://image.com',
    propertyType: 'House',
  );

  testWidgets('PropertyCard displays correct information', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PropertyCard(property: tProperty),
        ),
      ),
    );

    expect(find.text('Modern Villa'), findsOneWidget);
    expect(find.text('\$250000.00'), findsOneWidget);
    expect(find.text('4 Beds'), findsOneWidget);
    expect(find.text('House'), findsOneWidget);
  });
}
