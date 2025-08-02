import 'package:flutter/material.dart';

class NotesSection extends StatefulWidget {
  final List<Map<String, dynamic>> notes;

  const NotesSection({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer Notes',
              style: theme.textTheme.headlineSmall,
            ),
            OutlinedButton.icon(
              onPressed: () => _showAddNoteDialog(context),
              icon: Icon(Icons.add, size: 16),
              label: Text('Add Note'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (widget.notes.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No customer notes available',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add notes to track customer interactions and important information',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.notes.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = widget.notes[index];
              return _NoteItem(
                note: note,
                onEdit: () => _showEditNoteDialog(context, note),
                onDelete: () => _showDeleteNoteDialog(context, note),
              );
            },
          ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    _noteController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Customer Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note content:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Enter your note here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              minLines: 3,
            ),
            SizedBox(height: 16),
            Text(
              'This note will be attributed to your user account with current timestamp.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_noteController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                _addNote(_noteController.text.trim());
              }
            },
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Map<String, dynamic> note) {
    _noteController.text = note['note'] ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Original by: ${note['user']} on ${note['date']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note content',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              minLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Note updated successfully')),
              );
            },
            child: Text('Update Note'),
          ),
        ],
      ),
    );
  }

  void _showDeleteNoteDialog(BuildContext context, Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text(
            'Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Note deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addNote(String noteText) {
    final newNote = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now().toString().split(' ')[0],
      'user':
          'Current User', // In a real app, this would come from user session
      'note': noteText,
      'timestamp': DateTime.now().toString(),
    };

    setState(() {
      widget.notes.insert(0, newNote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note added successfully')),
    );
  }
}

class _NoteItem extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteItem({
    Key? key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = note['user'] ?? 'Unknown User';
    final date = note['date'] ?? 'Unknown Date';
    final noteText = note['note'] ?? '';
    final timestamp = note['timestamp'] ?? '';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primary.withAlpha(26),
                  child: Text(
                    user.isNotEmpty ? user[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTimestamp(timestamp, date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit Note')),
                    PopupMenuItem(value: 'delete', child: Text('Delete Note')),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                noteText,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp, String date) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final time =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return '$date at $time';
    } catch (e) {
      return date;
    }
  }
}
