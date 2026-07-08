<<<<<<< HEAD
import 'package:bookly_finder/main.dart';
=======
>>>>>>> master
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
<<<<<<< HEAD
  testWidgets('shows the book search home screen', (tester) async {
    await tester.pumpWidget(const BooklyFinderApp());

    expect(find.text('Bookly Finder'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Buscar livros'), findsOneWidget);
=======
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
>>>>>>> master
  });
}
