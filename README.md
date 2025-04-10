# Book Tracker App

A Flutter mobile application that allows users to track the books they are reading, have read, or want to read.

## Features

📚 **Bookshelf View**: Three categories to organize your books
- Currently Reading
- Read
- Want to Read

➕ **Add Books**: Manually add books with details like title, author, total pages, and reading progress.

🔍 **Search & Filter**: Search for books within your library and filter by genre.

📊 **Reading Progress**: Track your reading progress for each book by updating current page.

📝 **Notes & Highlights**: Add notes or highlights with page references to remember important parts of books.

🎯 **Reading Goals**: Set and track reading goals with different periods and metrics.

🌓 **Dark/Light Mode**: Toggle between light and dark themes to suit your preference.

📊 **Statistics**: View your reading statistics including total books, pages read, and more.

## Technical Details

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Local Storage**: SQLite via sqflite package
- **UI Design**: Material 3 design with custom components

## Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Android Studio or VS Code
- Android or iOS emulator/device

### Installation

1. Clone this repository:
```
git clone https://github.com/yourusername/book_tracker.git
```

2. Navigate to the project directory:
```
cd book_tracker
```

3. Get dependencies:
```
flutter pub get
```

4. Run the app:
```
flutter run
```

## App Structure

- `lib/models/`: Data classes for Book, Note, ReadingGoal
- `lib/providers/`: State management with Provider
- `lib/screens/`: UI screens for various features
- `lib/services/`: Database and other services
- `lib/widgets/`: Reusable UI components
- `lib/themes/`: App theme configuration
- `lib/utils/`: Utility functions and helpers

## Screenshots

*Screenshots will be added here*

## Future Enhancements

- **Barcode/ISBN Scanner**: Scan book barcodes to add books automatically
- **Book Cover API**: Fetch book covers from online APIs
- **Reading Statistics**: More detailed statistics and visualizations
- **Data Backup/Sync**: Cloud sync capability
- **Social Features**: Share your reading progress and recommendations

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Flutter team for the amazing framework
- All contributors and package authors used in this project
