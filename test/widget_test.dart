import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:youtube_videos/main.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Sign in page loads and switches provider', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // The background animates forever, so pump fixed frames instead of settling
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign in now'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('Apple'));
    await tester.pump(const Duration(seconds: 1));
    final appleTile = find.ancestor(of: find.text('Apple'), matching: find.byType(Row)).first;
    expect(find.descendant(of: appleTile, matching: find.byIcon(Icons.check)), findsOneWidget);
  });
}
