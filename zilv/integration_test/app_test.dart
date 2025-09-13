import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zilv/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app test', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Current Score'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('No behaviors yet. Add one!'), findsOneWidget);

    // Navigate to manage behaviors screen
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Add a new behavior
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Name'),
      'Read a book',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Points'), '10');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify the behavior is added
    expect(find.text('Read a book'), findsOneWidget);
    expect(find.text('Points: 10'), findsOneWidget);

    // Go back to home screen
    Navigator.of(tester.element(find.byType(Scaffold))).pop();
    await tester.pumpAndSettle();

    // Log the new behavior
    await tester.tap(find.text('Read a book'));
    await tester.pumpAndSettle();

    // Verify score is updated
    expect(find.text('10'), findsOneWidget);

    // Go back to manage behaviors and delete it
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify it's gone
    expect(find.text('Read a book'), findsNothing);
  });
}
