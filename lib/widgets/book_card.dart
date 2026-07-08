import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, this.onTap, this.onRemove});

  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: _BookCover(coverUrl: book.coverUrl),
        title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          book.author ?? 'Autor desconhecido',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium,
        ),
        trailing: onRemove == null
            ? const Icon(Icons.chevron_right)
            : IconButton(
                tooltip: 'Remover favorito',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (coverUrl == null || coverUrl!.isEmpty) {
      return Container(
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.menu_book_outlined, color: colorScheme.primary),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coverUrl!,
        width: 48,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Icon(Icons.menu_book_outlined, color: colorScheme.primary);
        },
      ),
    );
  }
}
