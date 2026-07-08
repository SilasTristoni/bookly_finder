import 'package:flutter/material.dart';

import '../models/book.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do livro')),
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
              icon: Icons.calendar_today_outlined,
              label: 'Primeira publicação',
              value: book.publishYearLabel,
            ),
            _DetailTile(
              icon: Icons.language_outlined,
              label: 'Idioma',
              value: book.language ?? 'Idioma não informado',
            ),
            _DetailTile(
              icon: Icons.confirmation_number_outlined,
              label: 'Edição',
              value: book.editionKey ?? 'Edição não informada',
            ),
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
