# Bookly Finder

Aplicativo mobile desenvolvido em Flutter para buscar livros na API pública da Open Library, visualizar informações básicas e salvar favoritos localmente para consulta posterior.

## Informações acadêmicas

**Curso:** Análise e Desenvolvimento de Sistemas  
**Unidade curricular:** Desenvolvimento Mobile com Flutter

## Alunos

- [Silas Tristoni](https://github.com/SilasTristoni)

> Caso a entrega seja em equipe, inclua aqui os demais integrantes com o link do perfil do GitHub antes da entrega final.

## Objetivo do projeto

O objetivo do Bookly Finder é oferecer uma experiência simples e funcional para:

1. pesquisar livros por título, autor ou palavra-chave;
2. consultar dados reais em uma API pública;
3. visualizar os resultados em uma lista organizada;
4. abrir a tela de detalhes de cada livro;
5. salvar e remover favoritos localmente.

## Tecnologias utilizadas

- **Flutter**: desenvolvimento da aplicação mobile.
- **Dart**: linguagem principal do projeto.
- **Material Design 3**: estrutura visual, tema, cards, ícones e componentes de interface.
- **HTTP**: consumo da API pública da Open Library.
- **Shared Preferences**: persistência local dos livros favoritos.
- **Git e GitHub**: versionamento, branches, commits e pull requests.

## API utilizada

O aplicativo consome a API pública da **Open Library** por meio do endpoint de busca:

```text
https://openlibrary.org/search.json?q=termo-da-busca
```

A partir do retorno da API, o app monta os dados do livro, como título, autor, capa, ano de primeira publicação, idioma, editora, edição e resumo curto quando essas informações estão disponíveis.

## Funcionalidades principais

- Tela inicial com campo de busca por título, autor ou palavra-chave.
- Consulta de livros na API pública Open Library.
- Exibição dos resultados em cards com título, autor, capa, ano e resumo curto.
- Tela de detalhes com informações adicionais do livro, como editora, ano, idioma, edição e resumo.
- Favoritar livros a partir da tela de detalhes.
- Tela específica para listar os livros favoritos.
- Remoção de livros da lista de favoritos.
- Persistência local dos favoritos entre execuções do aplicativo.
- Indicador de carregamento durante a consulta.
- Mensagens de feedback para busca vazia, ausência de resultados e falhas de rede.
- Navegação clara entre busca, detalhes e favoritos.
- Botão para limpar a busca e reiniciar a consulta.
- Interface com cards, ícones, imagens de capa e adaptação para telas pequenas e médias.

## Organização do código

A estrutura principal do projeto está separada por responsabilidade:

```text
lib/
├── main.dart
├── models/
│   └── book.dart
├── screens/
│   ├── details_screen.dart
│   ├── favorites_screen.dart
│   └── home_screen.dart
├── services/
│   ├── favorites_service.dart
│   └── open_library_service.dart
└── widgets/
    └── book_card.dart
```

### Responsabilidades dos arquivos

- `main.dart`: inicialização do aplicativo e configuração do tema.
- `models/book.dart`: modelo de dados do livro e conversões entre JSON/mapa.
- `services/open_library_service.dart`: comunicação com a API da Open Library e tratamento de erros.
- `services/favorites_service.dart`: gravação, leitura e remoção dos favoritos com Shared Preferences.
- `screens/home_screen.dart`: tela inicial, busca, loading, erros e listagem de resultados.
- `screens/details_screen.dart`: tela de detalhes e ação de favoritar/remover favorito.
- `screens/favorites_screen.dart`: tela com os livros favoritos salvos localmente.
- `widgets/book_card.dart`: card reutilizável usado na busca e nos favoritos.

## Tratamento de erros e feedback visual

O app trata diferentes cenários para melhorar a experiência do usuário:

- busca vazia;
- consulta sem resultados;
- falha de conexão;
- resposta inválida da API;
- timeout na requisição;
- falha ao salvar, carregar ou remover favoritos.

Esses casos exibem mensagens amigáveis na interface ou feedback por `SnackBar`.

## Como instalar e rodar o app

### Pré-requisitos

- Flutter SDK instalado.
- Android Studio, emulador Android ou dispositivo físico configurado.
- Git instalado na máquina.

### Passo a passo

Clone o repositório:

```bash
git clone https://github.com/SilasTristoni/bookly_finder.git
```

Acesse a pasta do projeto:

```bash
cd bookly_finder
```

Instale as dependências:

```bash
flutter pub get
```

Execute o app:

```bash
flutter run
```

## Testes

Para executar os testes automatizados existentes:

```bash
flutter test
```

## Organização do trabalho em equipe

O projeto foi organizado com branches, commits descritivos e pull requests para separar as principais entregas:

- estrutura inicial do app e navegação;
- integração com a API pública de livros;
- implementação de favoritos com armazenamento local;
- ajustes finais de interface, README e requisitos da atividade.

Essa organização facilita a revisão do código, mostra a evolução do desenvolvimento e atende ao critério de versionamento no GitHub.

## Critérios da atividade atendidos

- README completo e explicado.
- Código organizado por modelos, serviços, telas e widgets.
- Integração com API pública implementada.
- Armazenamento local implementado com Shared Preferences.
- Navegação entre busca, detalhes e favoritos.
- Interface com Material Design 3, cards, ícones e imagens.
- Tratamento de loading, erros e estados vazios.
- Possibilidade de limpar a busca.
- Histórico de commits e pull requests no GitHub.
