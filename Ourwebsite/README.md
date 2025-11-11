# 💞 Our Journey — Flutter + Firebase

A Flutter web experience that preserves the original “Our Journey” story while moving all dynamic behaviour to Firebase. The new stack replaces the legacy PHP/MySQL site with a modern, real‑time gallery and an authenticated dashboard for curating memories.

## ✨ Highlights

- **Story-first landing page** built with Flutter layouts and Google Fonts
- **Realtime gallery** backed by Cloud Firestore + Firebase Storage
- **Admin dashboard** for uploading and deleting photos (multi-upload, progress feedback)
- **Firebase Authentication** protects the dashboard
- **Responsive design** for desktop and mobile surfaces

## 🗂️ Project Structure

```
flutter_app/
├── lib/
│   ├── app.dart                # Root widget & app theme
│   ├── main.dart               # Firebase bootstrap & entrypoint
│   ├── firebase_options.dart   # Configured for the provided Firebase project (web)
│   ├── core/                   # Theme + router helpers
│   └── features/               # Landing, gallery, auth, and dashboard UI
├── web/                        # Flutter web shell (index + manifest)
├── pubspec.yaml                # Dependencies
└── analysis_options.yaml       # Lints
```

## 🚀 Getting Started

1. **Install prerequisites**
   - Flutter 3.24+ (`flutter --version`)
   - Dart SDK bundled with Flutter
   - Firebase CLI (optional but recommended)

2. **Fetch packages**
   ```bash
   cd flutter_app
   flutter pub get
   ```

3. **Run for web (Chrome)**
   ```bash
   flutter run -d chrome
   ```

4. **Build for web**
   ```bash
   flutter build web
   ```

> The provided `firebase_options.dart` is configured for the Firebase project that uses the supplied API keys. If you need Android/iOS/desktop builds, run `flutterfire configure` and extend `DefaultFirebaseOptions`.

## ☁️ Firebase Setup

The supplied configuration in `firebase_options.dart` matches:

```js
apiKey: "AIzaSyD24uQNUWsuvn3r6PZAkvDqUPOheQKhY7Q",
authDomain: "ourwebsite-44a4d.firebaseapp.com",
projectId: "ourwebsite-44a4d",
storageBucket: "ourwebsite-44a4d.firebasestorage.app",
messagingSenderId: "351109835631",
appId: "1:351109835631:web:41784c5a83f3d57f97969a"
```

Enable the following products:

- **Authentication** → Email/Password (create an admin user to match the SQL dump credentials)
- **Cloud Firestore** → Start in production mode, add `gallery_images` collection
- **Firebase Storage** → Set security rules to allow authenticated read/write

## 🛠️ Migrating From `ourwebsite_db (1).sql`

| Legacy Table        | Firebase Destination               | Notes                                                                                   |
|---------------------|------------------------------------|-----------------------------------------------------------------------------------------|
| `users`             | Firebase Authentication + Firestore| Create corresponding email/password users in Firebase Auth. Use proper email format.    |
| `gallery_images`    | Firestore `gallery_images` collection + Firebase Storage | Upload each image to Storage (`uploads/<uuid>.ext`); add document fields: `originalName`, `storagePath`, `downloadUrl`, `uploadedAt`. |

### Suggested migration flow

1. **Authentication**
   - For each entry in `users`, create a Firebase Auth user (e.g. via Firebase console or Admin SDK).
   - Update the password to a secure value (original dump stored plain text).
   - Optionally store profile info in a Firestore `users` collection (not required by the UI but helpful).

2. **Images**
   - For each row in `gallery_images`:
     1. Upload the referenced file from `/uploads` to Firebase Storage (`uploads/<generated-name>.jpg`).
     2. Obtain the download URL.
     3. Add a Firestore document with the fields described above.
   - The Flutter dashboard can also handle uploads manually if you prefer to rebuild from scratch.

3. **Verify**
   - Landing page should show the first 20 images.
   - Gallery page lists everything.
   - Dashboard displays cards for all stored images and allows removal.

## 🔐 Security Rules (baseline)

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /gallery_images/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}

service firebase.storage {
  match /b/{bucket}/o {
    match /uploads/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

Tighten as needed (e.g. restrict public reads if you plan to gate the gallery).

## ✅ Feature Parity Checklist

- [x] Story-driven landing page with hero, chapters, timeline, notes, and soundtrack link
- [x] Gallery preview (latest 20) with CTA to full gallery
- [x] Full gallery with lightbox viewer
- [x] Email/password login and logout
- [x] Dashboard for multi-upload + delete (real-time updates)

## 🧭 Next Steps

- Configure Firebase Hosting for one-command deploys (`firebase deploy --only hosting`)
- Add analytics or messaging if desired (Firebase SDK placeholders already available)
- Create automated migration scripts if you plan to re-seed regularly
