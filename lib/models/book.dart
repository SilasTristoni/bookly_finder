class Book {
  const Book({
    required this.title,
    required this.author,
    this.coverId,
    this.firstPublishYear,
    this.language,
    this.editionKey,
    this.publisher,
    this.description,
  });

  final String title;
  final String author;
  final int? coverId;
  final int? firstPublishYear;
  final String? language;
  final String? editionKey;
  final String? publisher;
  final String? description;

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = _stringList(json['author_name']);
    final languages = _stringList(json['language']);
    final editions = _stringList(json['edition_key']);
    final publishers = _stringList(json['publisher']);

    return Book(
      title: _stringValue(json['title']) ?? 'Titulo desconhecido',
      author: authors.isEmpty ? 'Autor desconhecido' : authors.join(', '),
      coverId: _intValue(json['cover_i']),
      firstPublishYear: _intValue(json['first_publish_year']),
      language: languages.isEmpty ? null : languages.first,
      editionKey: editions.isEmpty ? null : editions.first,
      publisher: publishers.isEmpty ? null : publishers.first,
      description:
          _firstStringValue(json['first_sentence']) ??
          _firstStringValue(json['subtitle']),
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: _stringValue(map['title']) ?? 'Titulo desconhecido',
      author: _stringValue(map['author']) ?? 'Autor desconhecido',
      coverId: _intValue(map['coverId']),
      firstPublishYear: _intValue(map['firstPublishYear']),
      language: _stringValue(map['language']),
      editionKey: _stringValue(map['editionKey']),
      publisher: _stringValue(map['publisher']),
      description: _stringValue(map['description']),
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
      return 'Ano nao informado';
    }

    return year.toString();
  }

  String get shortDescription {
    final text = description?.trim();
    if (text == null || text.isEmpty) {
      return 'Resumo nao informado pela API.';
    }

    return text;
  }

  String get favoriteKey {
    final normalizedEditionKey = editionKey?.trim();
    if (normalizedEditionKey != null && normalizedEditionKey.isNotEmpty) {
      return normalizedEditionKey;
    }

    return '${title.trim().toLowerCase()}-${author.trim().toLowerCase()}';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'coverId': coverId,
      'firstPublishYear': firstPublishYear,
      'language': language,
      'editionKey': editionKey,
      'publisher': publisher,
      'description': description,
    };
  }

  Map<String, dynamic> toJson() => toMap();

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

  static String? _firstStringValue(dynamic value) {
    if (value is List) {
      for (final item in value) {
        final text = _stringValue(item);
        if (text != null) {
          return text;
        }
      }

      return null;
    }

    return _stringValue(value);
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
