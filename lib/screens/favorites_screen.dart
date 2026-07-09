import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/favorites_service.dart';
import '../widgets/book_card.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, FavoritesService? favoritesService})
    : _favoritesService = favoritesService ?? const FavoritesService();

  final FavoritesService _favoritesService;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Book> _favorites = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    try {
      final favorites = await widget._favoritesService.getFavorites();

      if (!mounted) {
        return;
      }

      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);
      _showSnackBar('Nao foi possivel carregar os favoritos.');
    }
  }

  Future<void> _openDetails(Book book) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => DetailsScreen(book: book)));

    await _loadFavorites();
  }

  Future<void> _removeFavorite(Book book) async {
    try {
      await widget._favoritesService.removeFavorite(book);

      if (!mounted) {
        return;
      }

      setState(() {
        _favorites = _favorites
            .where((favorite) => favorite.favoriteKey != book.favoriteKey)
            .toList(growable: false);
      });

      _showSnackBar('Livro removido dos favoritos.');
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showSnackBar('Nao foi possivel remover o favorito.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const _EmptyFavorites();
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final book = _favorites[index];

          return BookCard(
            book: book,
            onTap: () => _openDetails(book),
            onRemove: () => _removeFavorite(book),
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum favorito ainda',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Os livros salvos localmente aparecerao aqui.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
