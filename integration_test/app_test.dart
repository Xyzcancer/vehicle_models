import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_project/main.dart' as app;
import 'package:test_project/widgets/widget_keys.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration test', () {
    testWidgets('ListView is displaying', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('List loaded', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      expect(find.text('TESLA, INC.'), findsOneWidget);
    });

    testWidgets('ListItems Tappable', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      var teslaItem = find.text('TESLA, INC.');
      await tester.tap(teslaItem);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key(WidgetKeys.modelsListView)), findsOneWidget);
    });
  });
}
