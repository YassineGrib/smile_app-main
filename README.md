# SmileApp - Nursery Management Application

Welcome to SmileApp, a comprehensive Flutter application designed to streamline nursery management for both administrators and parents. The app provides a user-friendly interface for parents to register their children, select care plans, and communicate with the nursery staff. It also includes a full-featured admin panel for managing the nursery's operations.

## ✨ Features

### For Parents:
- **🎬 Video Welcome Screen:** An engaging video to welcome new users.
- **📝 Easy Registration:** A multi-step registration process to capture child and parent information.
- **📅 Plan Selection:** Choose from various care plans (Morning, Evening, Full Day) with flexible duration options (Daily, Weekly, Monthly).
- **💬 Real-time Chat:** Communicate directly with the nursery support staff, with the ability to send text and images.
- **🎉 Events Page:** View and register for upcoming nursery events and activities.
- **🗓️ Book Visits:** Schedule a visit to the nursery facilities.

### For Admins:
- **🔐 Secure Login:** Protected access to the admin dashboard.
- **📊 Admin Dashboard:** An overview of nursery activities, including new registrations, messages, and visits.
- **📋 Manage Registrations:** View and manage all new registration applications.
- **👶 Manage Children & Parents:** Access and manage lists of registered children and parents.
- **✉️ View Messages:** Monitor and respond to inquiries from parents.

## 🚀 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Navigation:** [go_router](https://pub.dev/packages/go_router)
- **UI:** Custom widgets, [Google Fonts](https://pub.dev/packages/google_fonts)
- **Media:** [video_player](https://pub.dev/packages/video_player), [image_picker](https://pub.dev/packages/image_picker)

## 🏁 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation
1.  Clone the repo:
    ```sh
    git clone https://github.com/your-username/smile_app-main.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd smile_app-main
    ```
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```

## 📂 Project Structure

The project follows a standard Flutter project structure, with the core logic located in the `lib` directory:

```
lib/
├── models/         # Data models (Event, ChatMessage, etc.)
├── screens/        # UI for each screen/page
├── services/       # Services for data handling (e.g., DemoDataService)
├── utils/          # Utility classes (AppTheme, AppConstants)
└── widgets/        # Reusable custom widgets (EventCard, etc.)
```

## 📸 Screenshots

A folder named `Smile care screen shoots_` is available in the root directory containing various screenshots of the application.

---

This `README` provides a good starting point. Feel free to expand it with more details as the project grows!

