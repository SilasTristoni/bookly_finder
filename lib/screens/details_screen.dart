import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/favorites_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    this.book,
    FavoritesService? favoritesService,
  }) : _favoritesService = favoritesService ?? const FavoritesService();

  final Book? book;
  final FavoritesService _favoritesService;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final book = widget.book;

    if (book == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final isFavorite = await widget._favoritesService.isFavorite(book);

      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = isFavorite;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);
      _showSnackBar('Nao foi possivel verificar os favoritos.');
    }
  }

  Future<void> _toggleFavorite() async {
    final book = widget.book;

    if (book == null || _isUpdating) {
      return;
    }

    setState(() => _isUpdating = true);

    try {
      if (_isFavorite) {
        await widget._favoritesService.removeFavorite(book);
      } else {
        await widget._favoritesService.addFavorite(book);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = !_isFavorite;
        _isUpdating = false;
      });

      _showSnackBar(
        _isFavorite
            ? 'Livro adicionado aos favoritos.'
            : 'Livro removido dos favoritos.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isUpdating = false);
      _showSnackBar('Nao foi possivel atualizar os favoritos.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final title = book?.title ?? 'Detalhes do livro';
    final author = book?.author ?? 'Autor desconhecido';
    final description =
        book?.description ??
        'As informacoes completas do livro aparecerao aqui.';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (book != null)
            IconButton(
              tooltip: _isFavorite ? 'Remover favorito' : 'Adicionar favorito',
              onPressed: _isLoading || _isUpdating ? null : _toggleFavorite,
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(author, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
