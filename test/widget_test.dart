import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookly_finder/main.dart';

void main() {
  testWidgets('shows home screen and opens favorites', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BooklyFinderApp());

    expect(find.text('Bookly Finder'), findsOneWidget);
    expect(find.text('Pesquisar livros'), findsOneWidget);
    expect(find.text('Resultados'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_outline));
    await tester.pumpAndSettle();

    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });
}
