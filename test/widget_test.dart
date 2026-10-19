import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:youtube_videos/main.dart';

void main() {
  testWidgets('Sign up page loads', (WidgetTester tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(const MyApp());
    expect(find.text('Sign Up Account'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Github'), findsOneWidget);
  });
}
