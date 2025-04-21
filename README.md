# Book Tracker App

## Overview
Book Tracker is a cross-platform Flutter application that empowers users to manage their personal reading journey. The app allows you to track books you've read, are reading, or plan to read, set and monitor reading goals, and store notes—all with a privacy-first, offline-friendly approach. Authentication is handled via Firebase (email/password & Google), while all book and goal data is stored locally.

## Key Features
- **User Authentication**: Secure sign up, sign in, and password reset using Firebase Auth (email/password & Google Sign-In).
- **Bookshelf Management**: Add, edit, and organize books by status (Currently Reading, Want to Read, Read).
- **Reading Progress**: Update your current page and visualize progress.
- **Notes**: Attach notes and highlights to books.
- **Reading Goals**: Set, track, and complete custom reading goals (by books, pages, or minutes; daily, weekly, monthly, yearly, or custom period).
- **Statistics**: View summaries of your reading habits and achievements.
- **Dark/Light Mode**: Switch themes for comfortable reading.
- **Offline-First**: All book and goal data is stored locally (SQLite for mobile/desktop, SharedPreferences for web).

## Architecture & Design Decisions
- **Authentication**: Uses Firebase Auth for user login, signup, and Google Sign-In. No user data is stored in Firestore—only authentication.
- **Local Storage**: Book and goal data is stored locally. On mobile/desktop, SQLite is used; on web, SharedPreferences is used for persistence.
- **State Management**: Provider is used for efficient and scalable app state management.
- **Cross-Platform**: Runs on Android, iOS, Web, and Desktop.
- **UI**: Built with Material 3 for a modern, accessible experience.

## Project Structure
```
lib/
  models/              # Data models (Book, ReadingGoal, etc.)
  providers/           # State management (BookProvider, UserAuthProvider, etc.)
  screens/             # UI screens (login, signup, home, book details, add/edit, goals, etc.)
  services/            # Local storage, Firebase Auth integration
  utils/               # Validators and helpers
assets/images/         # App and Google logos
```

## Setup & Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/VyomPandya/Book_Tracker.git
   cd Book_Tracker
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Firebase Setup:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
   - Enable Email/Password and Google Sign-In in your Firebase project.
4. **Run the app:**
   ```sh
   flutter run
   ```

## Usage
- **Sign Up / Login:** Authenticate with email or Google.
- **Add/Edit Books:** Fill in book details and track reading status.
- **Add Notes:** Attach notes to any book.
- **Set Goals:** Tap the "+" button on the Goals screen to add a new goal.
- **Update Progress:** Use the "Update Progress" button on book details.
- **View Stats:** Access statistics from the home screen.

## Screenshots
*Add screenshots here to showcase the app UI.*

## Dependencies
- [Flutter](https://flutter.dev/)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [provider](https://pub.dev/packages/provider)
- [sqflite](https://pub.dev/packages/sqflite) (mobile/desktop)
- [shared_preferences](https://pub.dev/packages/shared_preferences) (web)
- [flutter_svg](https://pub.dev/packages/flutter_svg)

## Credits
Developed by VyomPandya (Vyom Pandya, 22it157@charusat.edu.in)

---
*This project is for educational purposes. For issues or contributions, please open an issue or pull request on GitHub.*
