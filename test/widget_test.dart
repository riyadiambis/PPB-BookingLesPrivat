import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:posttest1_booking_les_privat/main.dart';

void main() {
  testWidgets('Home page menampilkan judul dan search bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookingLesPrivatApp());

    expect(find.text('Booking Les Privat'), findsOneWidget);
    expect(find.text('Tutor Tersedia'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
