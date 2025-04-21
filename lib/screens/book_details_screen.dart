import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/screens/add_note_screen.dart';
import 'package:book_tracker/screens/update_progress_screen.dart';
import 'package:book_tracker/screens/add_book_screen.dart';
import 'package:book_tracker/widgets/note_card.dart';
import 'package:intl/intl.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookScreen(book: book),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context, bookProvider);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book header section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book cover
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: book.coverUrl.isNotEmpty
                        ? Image.network(
                            book.coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: colorScheme.primaryContainer,
                                child: Center(
                                  child: Text(
                                    book.title.substring(0, book.title.length > 1 ? 2 : 1),
                                    style: textTheme.headlineMedium?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: colorScheme.primaryContainer,
                            child: Center(
                              child: Text(
                                book.title.substring(0, book.title.length > 1 ? 2 : 1),
                                style: textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Book info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${book.author}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatusChip(context, book.status),
                      const SizedBox(height: 12),
                      if (book.status == ReadingStatus.currentlyReading)
                        LinearPercentIndicator(
                          lineHeight: 10,
                          percent: book.readingProgress,
                          progressColor: colorScheme.primary,
                          backgroundColor: colorScheme.primaryContainer,
                          barRadius: const Radius.circular(5),
                          padding: EdgeInsets.zero,
                        ),
                      if (book.status == ReadingStatus.currentlyReading)
                        const SizedBox(height: 4),
                      if (book.status == ReadingStatus.currentlyReading)
                        Text(
                          '${book.currentPage} of ${book.pageCount} pages (${(book.readingProgress * 100).toInt()}%)',
                          style: textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Book details section
            if (book.description.isNotEmpty) ...[
              Text(
                'Description',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                book.description,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            
            // Book metadata
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Pages', book.pageCount.toString()),
                    if (book.isbn.isNotEmpty)
                      _buildInfoRow('ISBN', book.isbn),
                    _buildInfoRow('Added on', DateFormat.yMMMd().format(book.addedDate)),
                    if (book.startedReading != null)
                      _buildInfoRow('Started reading', DateFormat.yMMMd().format(book.startedReading!)),
                    if (book.finishedReading != null)
                      _buildInfoRow('Finished reading', DateFormat.yMMMd().format(book.finishedReading!)),
                    if (book.genres.isNotEmpty)
                      _buildInfoRow('Genres', book.genres.join(', ')),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notes and highlights section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes & Highlights',
                  style: textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNoteScreen(bookId: book.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            book.notes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No notes or highlights yet',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: book.notes.length,
                    itemBuilder: (context, index) {
                      return NoteCard(
                        note: book.notes[index],
                        onDelete: () {
                          // TODO: Implement delete note functionality
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: book.status == ReadingStatus.currentlyReading
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProgressScreen(book: book),
                      ),
                    );
                  },
                  child: const Text('Update Progress'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusChip(BuildContext context, ReadingStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    String text;
    
    switch (status) {
      case ReadingStatus.currentlyReading:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        text = 'Currently Reading';
        break;
      case ReadingStatus.read:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = 'Read';
        break;
      case ReadingStatus.wantToRead:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'Want to Read';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BookProvider bookProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text(
          'Are you sure you want to delete "${book.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await bookProvider.deleteBook(book.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 