// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:itemtracker/main.dart';
import 'package:itemtracker/providers/ItemNotifier.dart';
import 'package:itemtracker/screen/ListingScreen.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('ItemListScreen should display items and add, edit, remove them',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ItemNotifier(),
        builder: (context, child) =>  const MaterialApp(
          home: ListingScreen(),
        ),
      ),
    );

    // Initial state should have no items
    expect(find.byType(Card), findsNothing);

    //
    // final addItemButtonFinder = find.byType(FloatingActionButton);
    // expect(addItemButtonFinder, findsOneWidget);

    // Add an item
    await tester.tap(find.byType( FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'SCBDH');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'KJVHKJDSBVJHDBVJHBJ');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Item Name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    // Edit the item
    await tester.tap(find.byKey(const Key('editButton_0')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).at(0), 'Edited Item Name');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Edited Item Description');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Item Name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    // Remove the item
    await tester.tap(find.byKey(const Key('deleteButton_0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete_yes')));
    await tester.pump();

    expect(find.byType(Card), findsNothing);
  });
}
