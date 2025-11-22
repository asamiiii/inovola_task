# GitHub Actions CI/CD Workflows

This directory contains GitHub Actions workflows for continuous integration and deployment.

## Workflows

### 🔍 CI Workflow (`ci.yml`)
**Triggers**: Push and PR to `main` and `develop` branches

**Jobs**:
- **Code Analysis**: Runs `flutter analyze` and format checking
- **Tests**: Executes `flutter test` with coverage reporting
- **Lint**: Verifies code follows lint rules with strict checking

### 📱 Android Build (`build_android.yml`)
**Triggers**: Push to `main` branch, manual dispatch

**Jobs**:
- **Build APK**: Generates debug and release APKs
- **Build App Bundle**: Creates AAB for Google Play Store

**Artifacts**: APKs (7 days retention), AAB (30 days retention)

### 🍎 iOS Build (`build_ios.yml`)
**Triggers**: Push to `main` branch, manual dispatch

**Jobs**:
- **Build iOS**: Generates unsigned IPA file

**Artifacts**: IPA (30 days retention)

> **Note**: Runs on macOS runners which consume more GitHub Actions minutes.

### ✅ PR Checks (`pr_checks.yml`)
**Triggers**: Pull requests to `main` and `develop` branches

**Jobs**:
- **Quick Validation**: Fast checks for formatting, dependencies, and basic analysis

## Features

- ✅ **Dependency Caching**: Flutter SDK, pub packages, Gradle, and CocoaPods
- ✅ **Code Generation**: Automatic Hive adapter generation
- ✅ **Parallel Execution**: Jobs run in parallel for faster feedback
- ✅ **Coverage Reporting**: Optional Codecov integration
- ✅ **Artifact Upload**: Build outputs available for download

## Manual Workflow Dispatch

You can manually trigger build workflows from the GitHub Actions tab:
1. Go to **Actions** tab in your repository
2. Select the workflow (e.g., "Build Android")
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

## Codecov Integration (Optional)

To enable code coverage reporting:
1. Sign up at [codecov.io](https://codecov.io)
2. Add your repository
3. Add `CODECOV_TOKEN` to repository secrets
4. Coverage reports will be uploaded automatically

## Secrets Configuration

For production builds with signing:

### Android Signing
Add these secrets to your repository:
- `ANDROID_KEYSTORE_BASE64`: Base64-encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Key alias
- `ANDROID_KEY_PASSWORD`: Key password

### iOS Signing
Add these secrets to your repository:
- `IOS_CERTIFICATE_BASE64`: Base64-encoded signing certificate
- `IOS_PROVISIONING_PROFILE_BASE64`: Base64-encoded provisioning profile
- `IOS_CERTIFICATE_PASSWORD`: Certificate password

## Troubleshooting

### Build Failures
- Check that all dependencies in `pubspec.yaml` are compatible
- Ensure code generation completes successfully locally
- Verify Flutter version compatibility

### Cache Issues
If you encounter cache-related problems:
1. Go to **Actions** → **Caches**
2. Delete relevant caches
3. Re-run the workflow

### iOS Build Issues
- Ensure CocoaPods dependencies are properly configured
- Check iOS deployment target compatibility
- Verify Xcode version requirements
