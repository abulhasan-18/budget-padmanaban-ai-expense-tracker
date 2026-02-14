# Google Sign-In Setup Guide - Budget Padmanaban

## Overview

This guide will help you integrate Google Sign-In with your Budget Padmanaban app using the Google Client IDs you created.

---

## Prerequisites

You mentioned you have created Client IDs in a "client folder". You should have:

1. **Android OAuth 2.0 Client ID** (from Google Cloud Console)
2. **iOS OAuth 2.0 Client ID** (from Google Cloud Console)
3. **Web Client ID** (optional, for Supabase authentication)

---

## Step 1: Download Configuration Files from Google Cloud Console

### For Android:

1. Go to: https://console.cloud.google.com/
2. Select your project
3. Go to **APIs & Services** → **Credentials**
4. Find your **Android OAuth 2.0 Client ID**
5. Look for a **Download JSON** button or option
6. If not available, you'll need to create a Firebase project (see Step 2)

### For iOS:

1. In the same **Credentials** page
2. Find your **iOS OAuth 2.0 Client ID**
3. Look for a **Download** option
4. If not available, you'll need to create a Firebase project (see Step 2)

---

## Step 2: Create Firebase Project (Recommended Method)

Firebase makes it easier to manage Google Sign-In configuration files.

### A. Create Firebase Project

1. Go to: https://console.firebase.google.com/
2. Click **Add project**
3. Project name: **Budget Padmanaban** (or your choice)
4. Enable Google Analytics: **Optional**
5. Click **Create project**

### B. Add Android App to Firebase

1. In Firebase Console, click **Add app** → **Android**
2. Enter details:
   - **Android package name**: `com.abulhasan.budget_padmanaban`
   - **App nickname**: Budget Padmanaban (optional)
   - **Debug signing certificate SHA-1**: `49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40`
3. Click **Register app**
4. **Download** `google-services.json`
5. Click **Next** → **Continue to console**

### C. Add iOS App to Firebase

1. In Firebase Console, click **Add app** → **iOS**
2. Enter details:
   - **iOS bundle ID**: `com.abulhasan.budgetPadmanaban`
   - **App nickname**: Budget Padmanaban (optional)
3. Click **Register app**
4. **Download** `GoogleService-Info.plist`
5. Click **Next** → **Continue to console**

### D. Add Release SHA-1 to Firebase

1. In Firebase Console → **Project Settings**
2. Select your **Android app**
3. Scroll to **SHA certificate fingerprints**
4. Click **Add fingerprint**
5. Add your **Release SHA-1**: `BF:29:4E:16:17:AE:4C:ED:94:4C:94:04:A7:1F:3D:D3:E8:0C:E0:06`
6. Click **Save**

---

## Step 3: Place Configuration Files in Your Project

### A. Android Configuration

1. **Locate** the downloaded `google-services.json` file
2. **Copy** it to: `android/app/google-services.json`

**File structure should be:**
```
budget_padmanaban/
└── android/
    └── app/
        └── google-services.json  ← Place here
```

### B. iOS Configuration

1. **Locate** the downloaded `GoogleService-Info.plist` file
2. **Copy** it to: `ios/Runner/GoogleService-Info.plist`

**File structure should be:**
```
budget_padmanaban/
└── ios/
    └── Runner/
        └── GoogleService-Info.plist  ← Place here
```

---

## Step 4: Update Android build.gradle

### A. Add Google Services Plugin

**File**: `android/build.gradle` (project-level)

Add this at the top:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.1'
    }
}
```

### B. Apply Plugin in App build.gradle

**File**: `android/app/build.gradle.kts`

Add at the bottom of the file:
```kotlin
apply(plugin = "com.google.gms.google-services")
```

---

## Step 5: Configure Supabase for Google Authentication

### A. Get Web Client ID

From Firebase Console:
1. Go to **Project Settings** → **General**
2. Scroll to **Your apps** section
3. Find **Web API Key** or create a **Web app**
4. Copy the **Web Client ID**

### B. Configure Supabase

1. Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
2. Click **Google** provider
3. Enable it
4. Add your **Client ID** (Web Client ID from Firebase)
5. Add your **Client Secret** (from Google Cloud Console)
6. Set **Authorized redirect URIs**:
   ```
   https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
   ```
7. Click **Save**

### C. Update Google Cloud Console Redirect URIs

1. Go to: https://console.cloud.google.com/apis/credentials
2. Find your **Web Client ID** (not Android or iOS)
3. Click to edit
4. Under **Authorized redirect URIs**, add:
   ```
   https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
   ```
5. Click **Save**

---

## Step 6: Update Your Code

### A. Add Google Sign-In Server Client ID

**File**: `lib/core/constants/app_constants.dart`

Add this constant:
```dart
class AppConstants {
  // ... existing constants ...

  // Google Sign-In (Web Client ID for Supabase)
  static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com';
}
```

Replace `YOUR_WEB_CLIENT_ID_HERE` with your actual Web Client ID from Firebase.

### B. Update Auth Service

The Google Sign-In is already implemented in your `auth_service.dart`. Just ensure the Web Client ID is correct.

---

## Step 7: Verify Your Client IDs

### Check Android Client ID

1. Open `android/app/google-services.json`
2. Look for `"client_id"` under `"oauth_client"`
3. Should look like: `"1234567890-abc123xyz.apps.googleusercontent.com"`

### Check iOS Client ID

1. Open `ios/Runner/GoogleService-Info.plist`
2. Look for `<key>CLIENT_ID</key>`
3. The next `<string>` contains your iOS Client ID

### Check Web Client ID

1. This is used in your app code (`app_constants.dart`)
2. Also used in Supabase Google Auth configuration
3. Format: `1234567890-abc123xyz.apps.googleusercontent.com`

---

## Manual Configuration (If Not Using Firebase)

If you're not using Firebase and only have OAuth Client IDs from Google Cloud Console:

### A. Create google-services.json Manually

**File**: `android/app/google-services.json`

```json
{
  "project_info": {
    "project_number": "YOUR_PROJECT_NUMBER",
    "project_id": "budget-padmanaban",
    "storage_bucket": "budget-padmanaban.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID",
        "android_client_info": {
          "package_name": "com.abulhasan.budget_padmanaban"
        }
      },
      "oauth_client": [
        {
          "client_id": "YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.abulhasan.budget_padmanaban",
            "certificate_hash": "49468f8fa71012bdb2c3cf1c52a5bcb000fb4340"
          }
        },
        {
          "client_id": "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "YOUR_API_KEY"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

Replace:
- `YOUR_PROJECT_NUMBER`: From Google Cloud Console
- `YOUR_APP_ID`: Generated ID
- `YOUR_ANDROID_CLIENT_ID`: Your Android OAuth Client ID
- `YOUR_WEB_CLIENT_ID`: Your Web OAuth Client ID
- `YOUR_API_KEY`: From Google Cloud Console

### B. Create GoogleService-Info.plist Manually

**File**: `ios/Runner/GoogleService-Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CLIENT_ID</key>
	<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.YOUR_REVERSED_ID</string>
	<key>API_KEY</key>
	<string>YOUR_API_KEY</string>
	<key>GCM_SENDER_ID</key>
	<string>YOUR_PROJECT_NUMBER</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>com.abulhasan.budgetPadmanaban</string>
	<key>PROJECT_ID</key>
	<string>budget-padmanaban</string>
	<key>STORAGE_BUCKET</key>
	<string>budget-padmanaban.appspot.com</string>
	<key>IS_ADS_ENABLED</key>
	<false/>
	<key>IS_ANALYTICS_ENABLED</key>
	<false/>
	<key>IS_APPINVITE_ENABLED</key>
	<false/>
	<key>IS_GCM_ENABLED</key>
	<false/>
	<key>IS_SIGNIN_ENABLED</key>
	<true/>
	<key>GOOGLE_APP_ID</key>
	<string>1:YOUR_PROJECT_NUMBER:ios:YOUR_APP_ID</string>
</dict>
</plist>
```

Replace:
- `YOUR_IOS_CLIENT_ID`: Your iOS OAuth Client ID
- `YOUR_REVERSED_ID`: Reverse of client ID (e.g., if client ID starts with `123456`, reversed is `com.googleusercontent.apps.123456-abc`)
- `YOUR_API_KEY`: From Google Cloud Console
- `YOUR_PROJECT_NUMBER`: From Google Cloud Console
- `YOUR_APP_ID`: Generated ID

---

## Step 8: Test Google Sign-In

### A. Clean and Rebuild

```bash
flutter clean
flutter pub get
```

### B. Run the App

```bash
flutter run
```

### C. Test Sign-In Flow

1. Open the app
2. Go to Login screen
3. Tap **"Sign in with Google"** button
4. Should open Google Sign-In sheet
5. Select your Google account
6. Should redirect back to app and sign in

---

## Quick Summary - What You Need to Do

1. ✅ **Download** `google-services.json` from Firebase or Google Cloud Console
2. ✅ **Place** it in `android/app/google-services.json`
3. ✅ **Download** `GoogleService-Info.plist` from Firebase or Google Cloud Console
4. ✅ **Place** it in `ios/Runner/GoogleService-Info.plist`
5. ✅ **Get** Web Client ID from Firebase
6. ✅ **Add** it to `lib/core/constants/app_constants.dart`
7. ✅ **Configure** Supabase Google Auth with Web Client ID
8. ✅ **Add** Supabase redirect URI to Google Cloud Console
9. ✅ **Test** Google Sign-In

---

## Your SHA Keys Reference

### Debug SHA-1 (Development):
```
49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40
```

### Release SHA-1 (Production):
```
BF:29:4E:16:17:AE:4C:ED:94:4C:94:04:A7:1F:3D:D3:E8:0C:E0:06
```

**Add BOTH to Firebase!**

---

## Troubleshooting

### Error: "Google Sign-In failed"
- Check that `google-services.json` is in correct location
- Verify SHA-1 keys are added to Firebase
- Ensure package name matches exactly

### Error: "Supabase auth error"
- Check Web Client ID in `app_constants.dart`
- Verify Supabase Google Auth is enabled
- Check redirect URI in Google Cloud Console

### Error: "Failed to load GoogleService-Info.plist"
- Verify file is in `ios/Runner/` directory
- Check file permissions
- Ensure bundle ID matches

---

## Next Steps After Setup

Once you have the configuration files in place:

1. Share the file contents with me or tell me you've placed them
2. I'll update your code with the correct Web Client ID
3. We'll test the Google Sign-In flow
4. Configure Supabase authentication

---

**Need Help?**

If you have the Client IDs from your "client folder", please share:
1. Android Client ID (looks like: `123456-abc.apps.googleusercontent.com`)
2. iOS Client ID (looks like: `123456-xyz.apps.googleusercontent.com`)
3. Web Client ID (looks like: `123456-web.apps.googleusercontent.com`)

I can then create the configuration files for you!

---

**Created**: February 14, 2026
**Status**: Waiting for configuration files
