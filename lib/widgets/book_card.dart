import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.onRemove,
  });

  final Book book;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              final details = _BookCardDetails(book: book);
              final action = _BookCardAction(onRemove: onRemove);

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CoverImage(book: book),
                        const Spacer(),
                        action,
                      ],
                    ),
                    const SizedBox(height: 12),
                    details,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CoverImage(book: book),
                  const SizedBox(width: 16),
                  Expanded(child: details),
                  const SizedBox(width: 8),
                  action,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookCardDetails extends StatelessWidget {
  const _BookCardDetails({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          book.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(book.publishYearLabel, style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _BookCardAction extends StatelessWidget {
  const _BookCardAction({required this.onRemove});

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    if (onRemove == null) {
      return const Icon(Icons.chevron_right);
    }

    return IconButton(
      tooltip: 'Remover favorito',
      onPressed: onRemove,
      icon: const Icon(Icons.delete_outline),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final coverUrl = book.coverUrl;

    if (coverUrl == null) {
      return const _CoverPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coverUrl,
        width: 72,
        height: 108,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _CoverPlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return const _CoverPlaceholder(showProgress: true);
        },
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 72,
      height: 108,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: showProgress
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.menu_book_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}
