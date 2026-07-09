import 'package:bookly_finder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows the book search home screen and opens favorites', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const BooklyFinderApp());

    expect(find.text('Bookly Finder'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Buscar livros'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });
}
