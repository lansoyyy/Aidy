import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showSearch(BuildContext context, List<Map<String, String>> notes) {
    showSearch(
      context: context,
      delegate: NotesSearchDelegate(notes),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder notes/recordings
    final notes = [
      {
        'title': 'Biology Lecture',
        'summary': 'Photosynthesis and plant cells overview.'
      },
      {
        'title': 'History Class',
        'summary': 'World War II: Causes and effects.'
      },
      {
        'title': 'Math Study',
        'summary': 'Algebraic equations and problem solving.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 12),
            TextWidget(
              text: 'Aidy',
              fontSize: 24,
              isBold: true,
              color: primary,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () => _showSearch(context, notes),
            tooltip: 'Search notes',
          ),
        ],
      ),
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            TextWidget(
              text: 'Your Notes',
              fontSize: 20,
              isBold: true,
              color: textLight,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: notes.isEmpty
                  ? Center(
                      child: TextWidget(
                        text: 'No notes yet. Tap + to start a new session!',
                        fontSize: 16,
                        color: textGrey,
                      ),
                    )
                  : ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          color: surface,
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/summary',
                                arguments: {'fromHome': true},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.sticky_note_2_outlined,
                                      color: accent, size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: note['title']!,
                                          fontSize: 16,
                                          isBold: true,
                                          color: primary,
                                        ),
                                        const SizedBox(height: 4),
                                        TextWidget(
                                          text: note['summary']!,
                                          fontSize: 14,
                                          color: textGrey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.chevron_right,
                                      color: grey, size: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          Navigator.of(context).pushNamed('/listen');
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        tooltip: 'Add new session',
      ),
    );
  }
}

class NotesSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, String>> notes;
  NotesSearchDelegate(this.notes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes
        .where((note) =>
            note['title']!.toLowerCase().contains(query.toLowerCase()) ||
            note['summary']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: TextWidget(
          text: 'No results found.',
          fontSize: 16,
          color: textGrey,
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final note = results[index];
        return Material(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => close(context, note['title']!),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: note['title']!,
                    fontSize: 18,
                    isBold: true,
                    color: primary,
                  ),
                  const SizedBox(height: 6),
                  TextWidget(
                    text: note['summary']!,
                    fontSize: 15,
                    color: textGrey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes
        .where((note) =>
            note['title']!.toLowerCase().contains(query.toLowerCase()) ||
            note['summary']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: TextWidget(
            text: note['title']!,
            fontSize: 16,
            isBold: true,
            color: primary,
          ),
          subtitle: TextWidget(
            text: note['summary']!,
            fontSize: 14,
            color: textGrey,
          ),
          onTap: () => close(context, note['title']!),
        );
      },
    );
  }
}
