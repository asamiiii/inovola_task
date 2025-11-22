# CI/CD Workflows

GitHub Actions workflows for automated builds and testing.

## Workflows

### 🔍 CI (`ci.yml`)
**Triggers**: Push/PR to `main` and `develop`

- Code analysis & formatting
- Tests with coverage
- Lint checking

### 📱 Android Build (`build_android.yml`)
**Triggers**: Push to `main`, manual

- Builds APK and AAB
- Artifacts: 7-30 days retention

### 🍎 iOS Build (`build_ios.yml`)
**Triggers**: Push to `main`, manual

- Builds unsigned IPA
- Runs on macOS runners

### ✅ PR Checks (`pr_checks.yml`)
**Triggers**: PRs to `main` and `develop`

- Quick validation checks

## Features

- ✅ Dependency caching (Flutter, Gradle, CocoaPods)
- ✅ Automatic Hive code generation
- ✅ Parallel job execution
- ✅ Build artifact uploads

## Manual Builds

1. Go to **Actions** tab
2. Select workflow
3. Click **Run workflow**
4. Download artifacts when complete

## Secrets (Optional)

For signed builds, add to repository secrets:

**Android**: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`

**iOS**: `IOS_CERTIFICATE_BASE64`, `IOS_PROVISIONING_PROFILE_BASE64`, `IOS_CERTIFICATE_PASSWORD`
