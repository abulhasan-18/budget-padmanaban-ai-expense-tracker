# Android Release Keystore - Budget Padmanaban

## IMPORTANT: KEEP THIS FILE SECURE AND PRIVATE!

This document contains critical information about your Android app's signing keys. **NEVER** share this information publicly or commit it to version control.

---

## Release Keystore Details

### Keystore Information
- **File Location**: `android/app/upload-keystore.jks`
- **Keystore Password**: `Budget@Padmanaban2026`
- **Key Alias**: `upload`
- **Key Password**: `Budget@Padmanaban2026`
- **Keystore Type**: JKS (Java KeyStore)
- **Key Algorithm**: RSA 2048-bit
- **Validity**: 10,000 days (until July 02, 2053)

### Certificate Details
- **Owner**: CN=Abul Hasan, OU=Development, O=Budget Padmanaban, L=Erode, ST=Tamil Nadu, C=IN
- **Issuer**: CN=Abul Hasan, OU=Development, O=Budget Padmanaban, L=Erode, ST=Tamil Nadu, C=IN
- **Serial Number**: e1c12837fe448a67
- **Valid From**: Sat Feb 14, 2026
- **Valid Until**: Wed Jul 02, 2053

---

## Release SHA-1 and SHA-256 Keys

### For Production/Release Builds

**SHA-1 Fingerprint:**
```
BF:29:4E:16:17:AE:4C:ED:94:4C:94:04:A7:1F:3D:D3:E8:0C:E0:06
```

**SHA-256 Fingerprint:**
```
EA:B6:FD:93:1F:E1:A4:08:F0:D7:4B:3C:1C:37:DE:05:90:E8:D2:49:27:CD:CF:41:22:2C:5E:B2:57:4E:D8:6F
```

### For Development/Debug Builds

**SHA-1 Fingerprint:**
```
49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40
```

**SHA-256 Fingerprint:**
```
B5:98:CC:3A:44:DF:E7:E7:F1:E4:F5:D8:4C:21:65:4E:19:FF:46:F1:CD:C2:F6:77:22:99:77:80:FF:90:1C:BC
```

---

## Files Created

1. **`android/app/upload-keystore.jks`** - The keystore file (NEVER commit to Git)
2. **`android/key.properties`** - Keystore credentials (NEVER commit to Git)
3. **`android/app/proguard-rules.pro`** - ProGuard rules for code obfuscation
4. **Updated `android/app/build.gradle.kts`** - Signing configuration

---

## Security Configuration

### .gitignore Updated
The following files are automatically excluded from Git:
- `*.jks`
- `*.keystore`
- `key.properties`
- `android/key.properties`
- `android/app/upload-keystore.jks`

### ProGuard Configuration
Code obfuscation and minification are enabled for release builds:
- `isMinifyEnabled = true`
- `isShrinkResources = true`
- ProGuard rules protect Flutter, Supabase, Google ML Kit, and other dependencies

---

## How to Use

### Build Release APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build Release App Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build and Install Release APK on Device
```bash
flutter run --release
```

---

## Google Play Store Setup

### Step 1: Add Release SHA-1 to Google Cloud Console

1. Go to: https://console.cloud.google.com/
2. Select your project or create a new one
3. Navigate to: **APIs & Services** → **Credentials**
4. Click **Create Credentials** → **OAuth client ID**
5. Select **Android**
6. Fill in:
   - **Name**: Budget Padmanaban (Release)
   - **Package name**: `com.abulhasan.budget_padmanaban`
   - **SHA-1**: `A2:0B:D5:C4:12:A8:28:8D:D8:B0:AA:5A:16:4C:B5:F1:1F:76:93:28`
7. Click **Create**

### Step 2: Add to Firebase (If Using)

1. Go to: https://console.firebase.google.com/
2. Select your project
3. Go to **Project Settings** → **Your apps** → Android app
4. Scroll to **SHA certificate fingerprints**
5. Click **Add fingerprint**
6. Add both Debug and Release SHA-1:
   - Debug: `49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40`
   - Release: `A2:0B:D5:C4:12:A8:28:8D:D8:B0:AA:5A:16:4C:B5:F1:1F:76:93:28`
7. Download updated `google-services.json`
8. Replace file in `android/app/google-services.json`

### Step 3: Configure Supabase for Google Auth

1. Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
2. Enable **Google** provider
3. Add **Authorized Client IDs** from Google Cloud Console
4. Configure redirect URLs

### Step 4: Upload to Google Play Console

1. Go to: https://play.google.com/console/
2. Create app or select existing app
3. Navigate to **Release** → **Production**
4. Click **Create new release**
5. Upload your **app-release.aab** file
6. Fill in release notes
7. Review and rollout

---

## Backup Your Keystore - CRITICAL!

### Why Backup?
- If you lose your keystore, you **CANNOT** update your app on Play Store
- You will have to publish a new app with a different package name
- All existing users will lose access to updates

### How to Backup

#### Option 1: Secure Cloud Storage
```bash
# Encrypt the keystore before uploading
gpg -c android/app/upload-keystore.jks
# Upload upload-keystore.jks.gpg to Google Drive, Dropbox, etc.
```

#### Option 2: Multiple Physical Locations
- Copy to external hard drive
- Copy to USB drive
- Store in safe location

#### Option 3: Password Manager
- Use 1Password, LastPass, or Bitwarden to store:
  - Keystore file (as attachment)
  - All passwords and details from this document

---

## Troubleshooting

### Error: "Keystore was tampered with, or password was incorrect"
- Check that password is exactly: `Budget@Padmanaban2026`
- Verify file path in `key.properties` is correct

### Error: "Failed to sign APK"
- Ensure `key.properties` exists in `android/` directory
- Verify keystore file exists at `android/app/upload-keystore.jks`
- Check file permissions

### Error: "ProGuard rules not applied"
- Verify `proguard-rules.pro` exists in `android/app/`
- Check `build.gradle.kts` has ProGuard configuration

### To Regenerate SHA Fingerprints
```bash
# For release keystore
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload -storepass "Budget@Padmanaban2026"

# For debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android
```

---

## Key Rotation (Advanced)

If you need to rotate your signing key in the future:

1. Generate new keystore with new alias
2. Sign APK with new key
3. In Play Console: **Release** → **Setup** → **App integrity**
4. Use **Play App Signing** to allow key rotation
5. Upload new signing key

---

## Summary

### What Was Done ✅
1. ✅ Generated 2048-bit RSA release keystore
2. ✅ Created `key.properties` with credentials
3. ✅ Updated `build.gradle.kts` with signing configuration
4. ✅ Added ProGuard rules for code obfuscation
5. ✅ Updated `.gitignore` to protect sensitive files
6. ✅ Generated SHA-1 and SHA-256 fingerprints

### Next Steps
1. **Backup your keystore immediately** (see Backup section)
2. Add Release SHA-1 to Google Cloud Console
3. Add SHA fingerprints to Firebase (if using)
4. Build release APK/AAB and test
5. Upload to Google Play Store

---

## Important Reminders

1. **NEVER** commit `upload-keystore.jks` to Git
2. **NEVER** commit `key.properties` to Git
3. **ALWAYS** backup your keystore in multiple locations
4. **NEVER** share your keystore passwords publicly
5. **USE** both Debug and Release SHA-1 keys in Google Cloud Console
6. **STORE** this document securely (password manager recommended)

---

## Contact Information

**App Name**: Budget Padmanaban - AI-Powered Expense Tracker
**Package Name**: com.abulhasan.budget_padmanaban
**Developer**: Abul Hasan
**Organization**: Budget Padmanaban

---

**Document Created**: February 14, 2026
**Last Updated**: February 14, 2026
**Status**: ✅ Production Ready
