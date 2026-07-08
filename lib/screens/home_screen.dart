import 'package:flutter/material.dart';

import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openFavorites(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()));
  }

  void _openDetails(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const DetailsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookly Finder'),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            onPressed: () => _openFavorites(context),
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBar(
            hintText: 'Pesquisar livros',
            leading: const Icon(Icons.search),
            trailing: const [Icon(Icons.tune)],
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Text('Resultados', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'A lista de livros pesquisados aparecerá aqui.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _openDetails(context),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Prévia de detalhes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
