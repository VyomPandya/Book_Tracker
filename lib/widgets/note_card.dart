import 'package:flutter/material.dart';
import 'package:book_tracker/models/book.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function()? onDelete;

  const NoteCard({
    super.key,
    required this.note,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: note.isHighlight 
          ? colorScheme.primary.withOpacity(0.1) 
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: note.isHighlight 
              ? colorScheme.primary.withOpacity(0.3) 
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  note.isHighlight ? Icons.format_quote : Icons.note,
                  size: 16,
                  color: note.isHighlight 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  note.isHighlight ? 'Highlight' : 'Note',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: note.isHighlight 
                        ? colorScheme.primary 
                        : colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                if (note.pageNumber > 0) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Page ${note.pageNumber}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  DateFormat.yMMMd().format(note.createdAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              note.content,
              style: note.isHighlight
                  ? textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface,
                    )
                  : textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            if (onDelete != null)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 