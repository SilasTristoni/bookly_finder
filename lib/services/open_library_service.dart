import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class OpenLibraryException implements Exception {
  const OpenLibraryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OpenLibraryService {
  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> searchBooks(String query) async {
    final term = query.trim();
    if (term.isEmpty) {
      return const [];
    }

    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': term,
      'fields': [
        'key',
        'title',
        'author_name',
        'cover_i',
        'first_publish_year',
        'language',
        'edition_key',
        'publisher',
        'first_sentence',
        'subtitle',
        'subject',
      ].join(','),
      'limit': '30',
    });

    late http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 12));
    } on TimeoutException {
      throw const OpenLibraryException(
        'A busca demorou demais. Tente novamente em instantes.',
      );
    } on http.ClientException {
      throw const OpenLibraryException(
        'Não foi possível conectar à Open Library.',
      );
    } catch (_) {
      throw const OpenLibraryException('Falha de rede ao buscar livros.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw OpenLibraryException(
        'A Open Library respondeu com erro ${response.statusCode}.',
      );
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const OpenLibraryException(
        'A Open Library retornou uma resposta inválida.',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const OpenLibraryException(
        'A Open Library retornou uma resposta inesperada.',
      );
    }

    final docs = decoded['docs'];
    if (docs is! List || docs.isEmpty) {
      return const [];
    }

    return docs
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList(growable: false);
  }

  void dispose() {
    _client.close();
  }
}
