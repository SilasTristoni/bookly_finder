class Book {
  const Book({
    required this.title,
    required this.author,
    this.coverId,
    this.firstPublishYear,
    this.language,
    this.editionKey,
  });

  final String title;
  final String author;
  final int? coverId;
  final int? firstPublishYear;
  final String? language;
  final String? editionKey;

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = _stringList(json['author_name']);
    final languages = _stringList(json['language']);
    final editions = _stringList(json['edition_key']);

    return Book(
      title: _stringValue(json['title']) ?? 'Título desconhecido',
      author: authors.isEmpty ? 'Autor desconhecido' : authors.join(', '),
      coverId: _intValue(json['cover_i']),
      firstPublishYear: _intValue(json['first_publish_year']),
      language: languages.isEmpty ? null : languages.first,
      editionKey: editions.isEmpty ? null : editions.first,
    );
  }

  String? get coverUrl {
    final id = coverId;
    if (id == null) {
      return null;
    }

    return 'https://covers.openlibrary.org/b/id/$id-M.jpg';
  }

  String get publishYearLabel {
    final year = firstPublishYear;
    if (year == null) {
      return 'Ano não informado';
    }

    return year.toString();
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Object>()
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String? _stringValue(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  static int? _intValue(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
