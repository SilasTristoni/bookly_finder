import 'package:bookly_finder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the book search home screen', (tester) async {
    await tester.pumpWidget(const BooklyFinderApp());

    expect(find.text('Bookly Finder'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Buscar livros'), findsOneWidget);
  });
}
