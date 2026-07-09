import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';

class FavoritesStorageException implements Exception {
  const FavoritesStorageException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'FavoritesStorageException: $message';
}

class FavoritesService {
  const FavoritesService();

  static const String _favoritesKey = 'favorite_books';

  Future<List<Book>> getFavorites() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final encodedBooks = preferences.getStringList(_favoritesKey) ?? [];

      return encodedBooks
          .map(_decodeBook)
          .whereType<Book>()
          .toList(growable: false);
    } catch (error) {
      throw FavoritesStorageException(
        'Nao foi possivel carregar os favoritos.',
        error,
      );
    }
  }

  Future<bool> isFavorite(Book book) async {
    final favorites = await getFavorites();

    return favorites.any((favorite) => _hasSameFavoriteKey(favorite, book));
  }

  Future<void> addFavorite(Book book) async {
    try {
      final favorites = await getFavorites();
      final alreadySaved = favorites.any(
        (favorite) => _hasSameFavoriteKey(favorite, book),
      );

      if (alreadySaved) {
        return;
      }

      await _saveFavorites([...favorites, book]);
    } catch (error) {
      if (error is FavoritesStorageException) {
        rethrow;
      }

      throw FavoritesStorageException(
        'Nao foi possivel salvar o favorito.',
        error,
      );
    }
  }

  Future<void> removeFavorite(Book book) async {
    try {
      final favorites = await getFavorites();
      final updatedFavorites = favorites
          .where((favorite) => !_hasSameFavoriteKey(favorite, book))
          .toList(growable: false);

      await _saveFavorites(updatedFavorites);
    } catch (error) {
      if (error is FavoritesStorageException) {
        rethrow;
      }

      throw FavoritesStorageException(
        'Nao foi possivel remover o favorito.',
        error,
      );
    }
  }

  Future<void> _saveFavorites(List<Book> favorites) async {
    final preferences = await SharedPreferences.getInstance();
    final encodedBooks = favorites
        .map((book) => jsonEncode(book.toMap()))
        .toList(growable: false);

    final saved = await preferences.setStringList(_favoritesKey, encodedBooks);

    if (!saved) {
      throw const FavoritesStorageException(
        'Nao foi possivel gravar os favoritos.',
      );
    }
  }

  Book? _decodeBook(String encodedBook) {
    try {
      final decodedBook = jsonDecode(encodedBook);

      if (decodedBook is! Map<String, dynamic>) {
        return null;
      }

      return Book.fromMap(decodedBook);
    } catch (_) {
      return null;
    }
  }

  bool _hasSameFavoriteKey(Book firstBook, Book secondBook) {
    return firstBook.favoriteKey == secondBook.favoriteKey;
  }
}
