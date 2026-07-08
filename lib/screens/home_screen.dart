import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/open_library_service.dart';
import '../widgets/book_card.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.service});

  final OpenLibraryService? service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final OpenLibraryService _service;
  late final bool _ownsService;

  List<Book> _books = const [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _emptyMessage;
  int _searchVersion = 0;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? OpenLibraryService();
    _ownsService = widget.service == null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_ownsService) {
      _service.dispose();
    }
    super.dispose();
  }

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    final version = ++_searchVersion;

    if (query.isEmpty) {
      setState(() {
        _books = const [];
        _isLoading = false;
        _errorMessage = null;
        _emptyMessage = 'Digite um título, autor ou palavra-chave para buscar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _emptyMessage = null;
    });

    try {
      final books = await _service.searchBooks(query);
      if (!mounted || version != _searchVersion) {
        return;
      }

      setState(() {
        _books = books;
        _isLoading = false;
        _emptyMessage = books.isEmpty
            ? 'Nenhum livro encontrado para "$query".'
            : null;
      });
    } on OpenLibraryException catch (error) {
      if (!mounted || version != _searchVersion) {
        return;
      }

      setState(() {
        _books = const [];
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted || version != _searchVersion) {
        return;
      }

      setState(() {
        _books = const [];
        _isLoading = false;
        _errorMessage = 'Não foi possível concluir a busca.';
      });
    }
  }

  void _openDetails(Book book) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => DetailsScreen(book: book)));
  }

  void _openFavorites() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookly Finder'),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            onPressed: _openFavorites,
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchBooks(),
                decoration: InputDecoration(
                  labelText: 'Buscar livros',
                  hintText: 'Título, autor ou palavra-chave',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Buscar',
                    onPressed: _isLoading ? null : _searchBooks,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildContent(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return _StatusMessage(
        key: const ValueKey('error'),
        icon: Icons.wifi_off_outlined,
        title: 'Busca indisponível',
        message: errorMessage,
        iconColor: theme.colorScheme.error,
      );
    }

    final emptyMessage = _emptyMessage;
    if (emptyMessage != null) {
      return _StatusMessage(
        key: const ValueKey('empty'),
        icon: Icons.search_off_outlined,
        title: 'Sem resultados',
        message: emptyMessage,
      );
    }

    if (_books.isEmpty) {
      return const _StatusMessage(
        key: ValueKey('initial'),
        icon: Icons.auto_stories_outlined,
        title: 'Encontre seu próximo livro',
        message: 'Pesquise por título, autor ou qualquer palavra-chave.',
      );
    }

    return ListView.builder(
      key: const ValueKey('results'),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return BookCard(book: book, onTap: () => _openDetails(book));
      },
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor ?? theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
