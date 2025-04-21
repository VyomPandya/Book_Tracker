import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/book_provider.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;
  const AddBookScreen({super.key, this.book});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  final _currentPageController = TextEditingController();
  final _genresController = TextEditingController();
  
  ReadingStatus _selectedStatus = ReadingStatus.wantToRead;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      final b = widget.book!;
      _titleController.text = b.title;
      _authorController.text = b.author;
      _isbnController.text = b.isbn;
      _descriptionController.text = b.description;
      _pagesController.text = b.pageCount.toString();
      _currentPageController.text = b.currentPage.toString();
      _genresController.text = b.genres.join(', ');
      _selectedStatus = b.status;
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    _currentPageController.dispose();
    _genresController.dispose();
    super.dispose();
  }
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final bookProvider = Provider.of<BookProvider>(context, listen: false);
        
        // Parse page numbers
        final pageCount = int.tryParse(_pagesController.text) ?? 0;
        final currentPage = int.tryParse(_currentPageController.text) ?? 0;
        
        // Parse genres from comma-separated string
        final genres = _genresController.text
            .split(',')
            .map((genre) => genre.trim())
            .where((genre) => genre.isNotEmpty)
            .toList();
        
        // Create book object
        final book = Book(
          id: widget.book?.id, // use existing id if editing
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          isbn: _isbnController.text.trim(),
          description: _descriptionController.text.trim(),
          pageCount: pageCount,
          currentPage: currentPage,
          status: _selectedStatus,
          genres: genres,
          coverUrl: widget.book?.coverUrl ?? '',
          notes: widget.book?.notes ?? [],
        );
        
        if (widget.book != null) {
          await bookProvider.updateBook(book);
        } else {
          await bookProvider.addBook(book);
        }
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving book: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Book' : 'Add Book'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter book title',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Author field
                    TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: 'Author',
                        hintText: 'Enter author name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an author';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Reading status dropdown
                    DropdownButtonFormField<ReadingStatus>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Reading Status',
                      ),
                      items: ReadingStatus.values.map((status) {
                        String label;
                        switch (status) {
                          case ReadingStatus.currentlyReading:
                            label = 'Currently Reading';
                            break;
                          case ReadingStatus.read:
                            label = 'Read';
                            break;
                          case ReadingStatus.wantToRead:
                            label = 'Want to Read';
                            break;
                        }
                        
                        return DropdownMenuItem(
                          value: status,
                          child: Text(label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // ISBN field (optional)
                    TextFormField(
                      controller: _isbnController,
                      decoration: const InputDecoration(
                        labelText: 'ISBN (Optional)',
                        hintText: 'Enter ISBN number',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Page count field
                    TextFormField(
                      controller: _pagesController,
                      decoration: const InputDecoration(
                        labelText: 'Total Pages',
                        hintText: 'Enter total number of pages',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Current page field (if currently reading)
                    if (_selectedStatus == ReadingStatus.currentlyReading)
                      TextFormField(
                        controller: _currentPageController,
                        decoration: const InputDecoration(
                          labelText: 'Current Page',
                          hintText: 'Enter your current page',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_selectedStatus == ReadingStatus.currentlyReading) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter current page';
                            }
                            final currentPage = int.tryParse(value);
                            final totalPages = int.tryParse(_pagesController.text) ?? 0;
                            if (currentPage != null && totalPages > 0 && currentPage > totalPages) {
                              return 'Current page cannot exceed total pages';
                            }
                          }
                          return null;
                        },
                      ),
                    if (_selectedStatus == ReadingStatus.currentlyReading)
                      const SizedBox(height: 16),
                    
                    // Genres field (optional)
                    TextFormField(
                      controller: _genresController,
                      decoration: const InputDecoration(
                        labelText: 'Genres (Optional)',
                        hintText: 'Enter genres separated by commas',
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    
                    // Description field (optional)
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter book description',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(isEditing ? 'Save Changes' : 'Add Book'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}