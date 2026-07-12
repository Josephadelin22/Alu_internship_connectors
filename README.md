# 🎓 ALU Internship Connector

Welcome to the **ALU Internship Connector**! 🚀 
This platform is a dedicated mobile application designed to bridge the gap between African Leadership University (ALU) students and promising Startups/Ventures. 

Whether you are a student looking for a meaningful way to contribute, or an entrepreneur looking for top-tier talent, this app provides a seamless, real-time, and beautifully designed experience.

---

## 🌟 Key Features

*   **Role-Based Routing:** The app automatically knows who you are. It dynamically redirects `students` to the opportunity feed and `startup_owners` to their management dashboard.
*   **Real-Time Sync:** Opportunities and job applications update instantly without refreshing, thanks to Firebase Streams.
*   **Student Portal:** 
    *   Browse a feed of the latest internships and jobs.
    *   View clean, detailed job descriptions with required skills (tags).
    *   Send applications securely with a one-click "Apply Now" button.
    *   Track application statuses (Pending, Accepted, Rejected) in a dedicated tab.
*   **Startup Dashboard:** 
    *   A dedicated, clutter-free workspace for venture owners.
    *   Publish new opportunities through a strict and validated form (Title, Job Type, Location, Tags).
*   **Premium UI/UX:** Built with a modern aesthetic using Google Fonts (Poppins & Inter), smooth shadows, and a polished purple-accented color palette.

---

## 🛠 Tech Stack

*   **Frontend:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [Riverpod](https://riverpod.dev/) (Modern approach: `Provider`, `StreamProvider`, `FutureProvider`)
*   **Backend & Auth:** [Firebase Authentication](https://firebase.google.com/docs/auth) & [Cloud Firestore](https://firebase.google.com/docs/firestore)

---

## 🏗 Architecture (Feature-First)

The codebase is strictly organized using a **Feature-Driven Architecture** to ensure the code remains scalable, clean, and bug-free:

```text
lib/
├── core/                   # Shared UI, custom themes, and global utilities
├── features/               
│   ├── auth/               # Login, User Models, Auth Repository, and Profile Screen
│   ├── applications/       # Application logic, tracking list, and status management
│   └── opportunities/      # Job feeds, Startup Dashboard, and Opportunity logic
└── main.dart               # App entry point & Dynamic Role Routing logic
```

---

## 🚀 Getting Started

Follow these simple steps to run the project locally on your machine.

### 1. Prerequisites
*   Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
*   Set up an Android Emulator or iOS Simulator.
*   Have a Firebase project ready.

### 2. Installation
Install the required dependencies:
```bash
flutter pub get
```

### 3. Firebase Setup
Since the app relies heavily on Firebase, link your project:
1. Run `flutterfire configure` to generate your `firebase_options.dart` file.
2. In your Firebase Console, ensure your Firestore database is active.
3. Enable **Email/Password** sign-in in the Firebase Authentication tab.



### 4. Run the App!
```bash
flutter run
```
*(Press `r` in the terminal for a Hot Reload!)*

---

## 🧪 How to Test Both Roles

1.  **As a Student:** Create a new account. By default, you will land on the Home Screen where you can browse and apply for jobs.
2.  **As a Startup:** Go to your Firebase Firestore console, find your user document in the `users` collection, and change the `role` field from `student` to `startup_owner`. Restart the app, and you will be magically redirected to the **Startup Dashboard** to start posting offers!

---
*Built with passion for the ALU ecosystem.* 🌍
