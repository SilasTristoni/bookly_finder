import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/favorites_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.book,
    FavoritesService? favoritesService,
  }) : _favoritesService = favoritesService ?? const FavoritesService();

  final Book book;
  final FavoritesService _favoritesService;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;
  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final isFavorite = await widget._favoritesService.isFavorite(widget.book);

      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = isFavorite;
        _isLoadingFavorite = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoadingFavorite = false);
      _showSnackBar('Nao foi possivel verificar os favoritos.');
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) {
      return;
    }

    setState(() => _isUpdatingFavorite = true);

    try {
      if (_isFavorite) {
        await widget._favoritesService.removeFavorite(widget.book);
      } else {
        await widget._favoritesService.addFavorite(widget.book);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = !_isFavorite;
        _isUpdatingFavorite = false;
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

      setState(() => _isUpdatingFavorite = false);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do livro'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remover favorito' : 'Adicionar favorito',
            onPressed: _isLoadingFavorite || _isUpdatingFavorite
                ? null
                : _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: _DetailsCover(book: book)),
            const SizedBox(height: 24),
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            _DetailTile(
              icon: Icons.person_outline,
              label: 'Autor',
              value: book.author,
            ),
            _DetailTile(
              icon: Icons.business_outlined,
              label: 'Editora',
              value: book.publisher ?? 'Editora nao informada',
            ),
            _DetailTile(
              icon: Icons.calendar_today_outlined,
              label: 'Primeira publicacao',
              value: book.publishYearLabel,
            ),
            _DetailTile(
              icon: Icons.language_outlined,
              label: 'Idioma',
              value: book.language ?? 'Idioma nao informado',
            ),
            _DetailTile(
              icon: Icons.confirmation_number_outlined,
              label: 'Edicao',
              value: book.editionKey ?? 'Edicao nao informada',
            ),
            const SizedBox(height: 24),
            Text(
              'Resumo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(book.shortDescription, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _DetailsCover extends StatelessWidget {
  const _DetailsCover({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final coverUrl = book.coverUrl;

    if (coverUrl == null) {
      return const _DetailsCoverPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coverUrl,
        width: 150,
        height: 225,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _DetailsCoverPlaceholder(),
      ),
    );
  }
}

class _DetailsCoverPlaceholder extends StatelessWidget {
  const _DetailsCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 150,
      height: 225,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book_outlined,
        size: 64,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
