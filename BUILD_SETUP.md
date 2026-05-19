# CCQ Task Tracker - Build & Release Guide

## Overview

This app uses GitHub Actions to automatically build and release Android APKs whenever code is pushed to the `main` branch.

## GitHub Actions Workflow

**Location:** `.github/workflows/build.yml`

### What It Does
1. Triggers on push to `main` branch
2. Sets up Flutter 3.44.0 environment
3. Gets version from `pubspec.yaml`
4. Runs `flutter pub get`
5. Builds release APK with `flutter build apk --release`
6. Creates GitHub Release with the APK
7. Uploads `update.json` for in-app updates

### Version Format
The app uses semantic versioning in `pubspec.yaml`:
```
version: MAJOR.MINOR.PATCH+BUILD_NUMBER
Example: 1.0.3+5
```

- `versionCode` (in update.json) = BUILD_NUMBER (after the +)
- `versionName` = FULL version string

### How to Release a New Version

1. **Edit pubspec.yaml** - Increment the build number:
   ```yaml
   version: 1.0.3+6  # bump from 1.0.3+5
   ```

2. **Push to main:**
   ```bash
   git add -A
   git commit -m "Release: bump version to 1.0.3+6"
   git push origin main
   ```

3. **GitHub Actions** will:
   - Build the APK (~7 minutes)
   - Create a GitHub Release
   - Upload the APK and update.json

### If Release Creation Fails

The build may succeed but release creation fails due to token permissions. In that case:

1. Go to: https://github.com/Harsh-6361/CCQ-task-mangement-app/actions
2. Find the latest run
3. Download the APK from the Artifacts
4. Create release manually:
   ```bash
   gh release create v1.0.3+6 --title "Release v1.0.3+6"
   gh release upload v1.0.3+6 path/to/app-release.apk
   ```

## In-App Updates

The app checks for updates on startup using `lib/common/services/app_update_service.dart`.

### How It Works
1. Fetches `update.json` from GitHub release
2. Compares local version with remote
3. If update available, shows dialog with:
   - Version name
   - Release notes
   - "Download" button

### Update.json Format
```json
{
  "versionCode": 5,
  "versionName": "1.0.3+5",
  "apkUrl": "https://github.com/.../releases/download/v1.0.3+5/app-release.apk",
  "notes": "Bug fixes and improvements"
}
```

## Troubleshooting

### Dart SDK Version Mismatch
If build fails with "requires SDK version ^3.11.5", update the Flutter version in the workflow:
```yaml
flutter-version: '3.44.0'  # Use a version with Dart 3.11.x
```

### Token Permissions
If release creation fails (403 error), the GitHub token needs `repo` and `workflow` scopes. Create a Personal Access Token at: https://github.com/settings/tokens

### Local Development
```bash
# Get dependencies
flutter pub get

# Run code generator (after editing .dart files with annotations)
flutter pub run build_runner build --delete-conflicting-outputs

# Build APK locally
flutter build apk --release

# Run on connected device
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── common/
│   ├── services/
│   │   ├── app_update_service.dart   # Update checking
│   │   └── notification_service.dart # Local notifications
│   └── widgets/
│       └── main_layout.dart          # App shell
├── features/
│   ├── auth/           # Login, signup, profile
│   ├── tasks/          # Task management
│   ├── crm/           # Leads and meetings
│   ├── groups/        # Teams/groups
│   ├── dashboard/     # Dashboard, calendar
│   └── admin/         # Admin panel
```

## Tech Stack

- **Flutter** 3.44.0
- **Dart** 3.11.x
- **Firebase** (Auth + Firestore)
- **Riverpod** for state management
- **GoRouter** for navigation
- **freezed** + **json_serializable** for data classes