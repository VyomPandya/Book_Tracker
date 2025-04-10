import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/providers/reading_goal_provider.dart';
import 'package:book_tracker/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final goalProvider = Provider.of<ReadingGoalProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Calculate statistics
    final totalBooks = bookProvider.allBooks.length;
    final booksRead = bookProvider.read.length;
    final currentlyReading = bookProvider.currentlyReading.length;
    final wantToRead = bookProvider.wantToRead.length;
    
    final totalPages = bookProvider.allBooks.fold<int>(
      0, (sum, book) => sum + book.pageCount);
    final pagesRead = bookProvider.read.fold<int>(
      0, (sum, book) => sum + book.pageCount);
    final currentProgress = bookProvider.currentlyReading.fold<int>(
      0, (sum, book) => sum + book.currentPage);
    
    final activeGoals = goalProvider.activeGoals.length;
    final completedGoals = goalProvider.completedGoals.length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bookProvider.loadBooks();
          await goalProvider.loadGoals();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primary,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Book Lover',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Joined April 2025',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Reading statistics
              Text(
                'Reading Statistics',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Statistics cards
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Total Books',
                    totalBooks.toString(),
                    Icons.menu_book,
                    colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Books Read',
                    booksRead.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Currently Reading',
                    currentlyReading.toString(),
                    Icons.auto_stories,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Want to Read',
                    wantToRead.toString(),
                    Icons.bookmark,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Pages Read',
                    pagesRead.toString(),
                    Icons.description,
                    Colors.purple,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Current Progress',
                    '$currentProgress pages',
                    Icons.trending_up,
                    Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Active Goals',
                    activeGoals.toString(),
                    Icons.flag,
                    Colors.amber,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Completed Goals',
                    completedGoals.toString(),
                    Icons.emoji_events,
                    Colors.green,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Settings section
              Text(
                'Settings',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              Card(
                child: Column(
                  children: [
                    // Dark mode toggle
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      secondary: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                    ),
                    
                    const Divider(),
                    
                    // App info
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About'),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Book Tracker',
                          applicationVersion: '1.0.0',
                          applicationIcon: FlutterLogo(
                            size: 50,
                            style: FlutterLogoStyle.stacked,
                          ),
                          children: [
                            const Text(
                              'A book tracking application that allows users to manage their reading journey.',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 