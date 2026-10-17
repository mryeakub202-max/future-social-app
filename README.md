# Future Social Media App (Flutter starter)

A bilingual (Bangla/English) dark premium social app starter.

## Current demo features
- Login/sign-up screen UI with language toggle
- Home feed with local in-memory post creation
- Like toggle on feed posts
- Reels placeholder screen
- Messages list with chat backend notice
- Profile screen and logout
- Bottom navigation

## Important limitations
This starter is a UI prototype, not a production social network yet. Login does **not** authenticate a real user; posts are stored only in memory and disappear after restarting. Reels playback/uploads, real-time messages, push notifications, password reset, and persistent profiles need a backend and additional implementation.

## Build an APK using only an Android phone (cloud build)
This project includes a GitHub Actions workflow at `.github/workflows/build-apk.yml`. It builds the APK on GitHub's cloud computers, so you do not need to install Flutter or Android Studio on your phone.

1. Download and extract this ZIP on your phone.
2. In your phone browser, sign in to GitHub and create a **new public repository** named `future-social-app` (public makes the first setup simpler; do not upload secrets or personal data).
3. Upload the project files and folders to the repository root. Make sure the `.github/workflows/build-apk.yml` file is included. Some mobile upload interfaces hide dot-folders; if you cannot upload that folder, use GitHub's web editor to create `.github/workflows/build-apk.yml` and paste in the workflow contents from the ZIP.
4. Open the repository's **Actions** tab. Select **Build Future Android APK**, then tap **Run workflow** if it has not started automatically.
5. Wait for the workflow to finish successfully. Open that run, scroll to **Artifacts**, and download `future-release-apk`.
6. Extract the downloaded artifact ZIP; inside is `app-release.apk`. Open it on your phone and allow installation from that source if Android asks.

If you use a private repository, check your GitHub Actions minutes/availability. GitHub may change its interface or limits.

## Run on a computer with Flutter installed
1. Install Flutter SDK and Android Studio.
2. In the project folder, run:
   ```bash
   flutter create . --platforms=android --project-name=future_social_app
   flutter pub get
   flutter run
   ```
3. To build an Android APK:
   ```bash
   flutter build apk --release
   ```
   APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Production next steps
1. Create a Firebase project.
2. Configure FlutterFire for Android.
3. Add Firebase Authentication (email/phone), Cloud Firestore, Firebase Storage, and Firebase Cloud Messaging.
4. Add server-side access rules, reporting/blocking, moderation, upload limits, and privacy controls before public launch.

This ZIP contains source code and an automated cloud-build workflow, not a precompiled APK. A working APK must be built using Flutter and Android build tools (locally or through the included GitHub Actions workflow).
