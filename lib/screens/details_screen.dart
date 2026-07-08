import 'package:flutter/material.dart';

import '../models/book.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, this.book});

  final Book? book;

  @override
  Widget build(BuildContext context) {
    final title = book?.title ?? 'Detalhes do livro';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              'As informações completas do livro serão exibidas aqui.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
