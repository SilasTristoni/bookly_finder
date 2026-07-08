class Book {
  const Book({
    required this.id,
    required this.title,
    this.editionKey,
    this.author,
    this.coverUrl,
    this.description,
  });

  final String id;
  final String title;
  final String? editionKey;
  final String? author;
  final String? coverUrl;
  final String? description;

  String get favoriteKey {
    final normalizedEditionKey = editionKey?.trim();

    if (normalizedEditionKey != null && normalizedEditionKey.isNotEmpty) {
      return normalizedEditionKey;
    }

    if (id.trim().isNotEmpty) {
      return id.trim();
    }

    return '${title.trim().toLowerCase()}-${author?.trim().toLowerCase() ?? ''}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'editionKey': editionKey,
      'author': author,
      'coverUrl': coverUrl,
      'description': description,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String? ?? map['editionKey'] as String? ?? '',
      title: map['title'] as String? ?? 'Titulo indisponivel',
      editionKey: map['editionKey'] as String?,
      author: map['author'] as String?,
      coverUrl: map['coverUrl'] as String?,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory Book.fromJson(Map<String, dynamic> json) => Book.fromMap(json);
}
