# Complete Supabase Google Sign-In Setup Guide

## Overview

This guide will walk you through setting up Google Sign-In for your Budget Padmanaban app using Supabase authentication.

---

## Step 1: Get Your Google OAuth Credentials

You mentioned you have client IDs. You should have these from Google Cloud Console:

1. **Web Client ID** (for Supabase)
2. **Web Client Secret** (for Supabase)
3. **Android Client ID** (for your app)
4. **iOS Client ID** (for your app)

---

## Step 2: Configure Google Provider in Supabase

### A. Navigate to Authentication Settings

1. Go to your Supabase Dashboard:
   ```
   https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa
   ```

2. In the left sidebar, click **Authentication**

3. Click **Providers**

4. Scroll down and find **Google**

### B. Enable Google Provider

1. Click on **Google** to expand it

2. Toggle the **Enable** switch to ON (it will turn green)

### C. Add Google OAuth Credentials

You'll see a form with these fields:

#### **Authorized Client IDs** (Required)
Paste your **Web Client ID** here. It looks like:
```
123456789-abcdefghijk.apps.googleusercontent.com
```

**Where to find it:**
- Google Cloud Console → APIs & Services → Credentials
- Look for "OAuth 2.0 Client IDs" → Type: **Web application**
- Copy the **Client ID**

#### **Client ID (for OAuth)** (Required)
Same as above - paste your **Web Client ID** again:
```
123456789-abcdefghijk.apps.googleusercontent.com
```

#### **Client Secret (for OAuth)** (Required)
Paste your **Client Secret** here. It looks like:
```
GOCSPX-abcdefghijklmnopqrstuvwxyz
```

**Where to find it:**
- Google Cloud Console → APIs & Services → Credentials
- Click on your **Web application** OAuth client
- You'll see **Client Secret**
- Click the **copy** icon to copy it

### D. Configure Redirect URL

This is pre-filled by Supabase. It should be:
```
https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

**IMPORTANT:** Copy this URL - you'll need it in Step 3!

### E. Additional Scopes (Optional)

You can leave this empty or add:
```
email profile openid
```

### F. Skip if null (Optional)

Leave this unchecked (default)

### G. Save Configuration

Click the **Save** button at the bottom

---

## Step 3: Add Supabase Redirect URI to Google Cloud Console

### A. Go to Google Cloud Console

1. Open: https://console.cloud.google.com/

2. Select your project

3. Navigate to: **APIs & Services** → **Credentials**

### B. Edit Web Application OAuth Client

1. Find your **OAuth 2.0 Client IDs**

2. Click on your **Web application** client (NOT Android or iOS)

3. Scroll down to **Authorized redirect URIs**

### C. Add Supabase Callback URL

Click **+ ADD URI** and paste:
```
https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

### D. Save Changes

Click **SAVE** at the bottom

---

## Step 4: Configure Your App with Client IDs

Now you need to add the client IDs to your Flutter app.

### A. Update App Constants

**File**: `lib/core/constants/app_constants.dart`

Add these constants:

```dart
class AppConstants {
  // ... existing constants ...

  // Google Sign-In Configuration
  static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
  static const String googleAndroidClientId = 'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com';
  static const String googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';
}
```

**Replace with your actual Client IDs:**
- `YOUR_WEB_CLIENT_ID`: The Web Client ID you used in Supabase
- `YOUR_ANDROID_CLIENT_ID`: Android OAuth Client ID from Google Cloud Console
- `YOUR_IOS_CLIENT_ID`: iOS OAuth Client ID from Google Cloud Console

### B. Update Auth Service (If Needed)

**File**: `lib/features/auth/providers/auth_service.dart`

The Google Sign-In should use the Web Client ID for Supabase:

```dart
Future<void> signInWithGoogle() async {
  try {
    // Use native Google Sign-In
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.budgetpadmanaban://login-callback/',
      authScreenLaunchMode: LaunchMode.inAppWebView,
    );
  } catch (e) {
    throw Exception('Google Sign-In failed: $e');
  }
}
```

---

## Step 5: Visual Guide - Where to Find Everything

### In Google Cloud Console:

```
Google Cloud Console
│
├── APIs & Services
│   └── Credentials
│       │
│       ├── OAuth 2.0 Client IDs
│       │   │
│       │   ├── Web application
│       │   │   ├── Client ID: [Copy this for Supabase]
│       │   │   ├── Client Secret: [Copy this for Supabase]
│       │   │   └── Authorized redirect URIs: [Add Supabase callback here]
│       │   │
│       │   ├── Android
│       │   │   ├── Client ID: [Use in app]
│       │   │   └── SHA-1: [Already configured]
│       │   │
│       │   └── iOS
│       │       └── Client ID: [Use in app]
```

### In Supabase Dashboard:

```
Supabase Dashboard
│
└── Authentication
    └── Providers
        └── Google
            ├── Enable: ✓ ON
            ├── Authorized Client IDs: [Web Client ID]
            ├── Client ID (for OAuth): [Web Client ID]
            ├── Client Secret: [Web Client Secret]
            └── Redirect URL: [Copy to Google Cloud Console]
```

---

## Step 6: Complete Setup Checklist

### ✅ In Google Cloud Console:

- [ ] Created Web OAuth 2.0 Client ID
- [ ] Created Android OAuth 2.0 Client ID (with SHA-1)
- [ ] Created iOS OAuth 2.0 Client ID (with Bundle ID)
- [ ] Added Supabase callback URL to Web Client's Authorized redirect URIs
- [ ] Copied Web Client ID
- [ ] Copied Web Client Secret
- [ ] Added both Debug and Release SHA-1 fingerprints to Android Client

**Your SHA Keys:**
- Debug: `49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40`
- Release: `BF:29:4E:16:17:AE:4C:ED:94:4C:94:04:A7:1F:3D:D3:E8:0C:E0:06`

### ✅ In Supabase Dashboard:

- [ ] Navigated to Authentication → Providers → Google
- [ ] Enabled Google provider
- [ ] Pasted Web Client ID in "Authorized Client IDs"
- [ ] Pasted Web Client ID in "Client ID (for OAuth)"
- [ ] Pasted Web Client Secret in "Client Secret"
- [ ] Verified Redirect URL matches Supabase callback
- [ ] Clicked Save

### ✅ In Your Flutter App:

- [ ] Updated `lib/core/constants/app_constants.dart` with all three Client IDs
- [ ] Verified `auth_service.dart` uses Google Sign-In correctly
- [ ] App builds without errors

---

## Step 7: Test Google Sign-In

### A. Run Your App

```bash
flutter run
```

### B. Test the Flow

1. App opens with **Splash Screen**
2. Navigate to **Login Screen**
3. Tap **"Sign in with Google"** button
4. Google Sign-In sheet should appear
5. Select your Google account
6. Grant permissions
7. App should redirect back and log you in
8. Check Supabase Dashboard → Authentication → Users

You should see your Google account listed!

---

## Step 8: Verify Everything Works

### A. Check Supabase Logs

1. Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/users

2. After signing in, you should see a new user with:
   - Email from Google account
   - Provider: google
   - Created timestamp

### B. Check App State

After successful sign-in:
- User should be redirected to home/dashboard
- User data should be available in `authProvider`
- Session should be saved securely

---

## Troubleshooting

### Error: "Invalid OAuth client"

**Cause:** Client ID or Secret is wrong

**Fix:**
1. Double-check Client ID in Supabase matches Google Cloud Console
2. Ensure you're using **Web** Client ID, not Android/iOS
3. Copy-paste carefully (no extra spaces)

### Error: "Redirect URI mismatch"

**Cause:** Supabase callback URL not added to Google Cloud Console

**Fix:**
1. Go to Google Cloud Console → Credentials
2. Edit **Web application** OAuth client
3. Add: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`
4. Save

### Error: "Sign-in failed"

**Cause:** Multiple possible issues

**Fix:**
1. Check internet connection
2. Verify Supabase project is active
3. Check auth service implementation
4. Look at Flutter console logs for specific error

### Error: "Google Sign-In canceled"

**Cause:** User canceled the sign-in

**Fix:** This is expected behavior - user chose not to sign in

---

## Quick Reference - All URLs

### Supabase Dashboard:
```
Main: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa
Auth Providers: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
Users: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/users
```

### Google Cloud Console:
```
Main: https://console.cloud.google.com/
Credentials: https://console.cloud.google.com/apis/credentials
```

### Supabase Callback URL (Add to Google):
```
https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

---

## Example: Complete Configuration

### Google Cloud Console - Web Client

```
Name: Budget Padmanaban (Web)
Application type: Web application
Client ID: 123456789-abc123xyz.apps.googleusercontent.com
Client Secret: GOCSPX-abcdefghijklmnopqrstuvwxyz

Authorized redirect URIs:
  - https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

### Supabase - Google Provider Settings

```
Enabled: ✓ Yes

Authorized Client IDs:
123456789-abc123xyz.apps.googleusercontent.com

Client ID (for OAuth):
123456789-abc123xyz.apps.googleusercontent.com

Client Secret (for OAuth):
GOCSPX-abcdefghijklmnopqrstuvwxyz

Redirect URL:
https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback

Additional Scopes:
email profile openid
```

### App Constants

```dart
// lib/core/constants/app_constants.dart

class AppConstants {
  // Google Sign-In
  static const String googleWebClientId = '123456789-abc123xyz.apps.googleusercontent.com';
  static const String googleAndroidClientId = '123456789-android.apps.googleusercontent.com';
  static const String googleIosClientId = '123456789-ios.apps.googleusercontent.com';
}
```

---

## What Happens When User Signs In?

1. **User taps "Sign in with Google"**
   - App calls `signInWithGoogle()` from auth_service.dart

2. **Supabase handles OAuth flow**
   - Opens Google Sign-In in browser/webview
   - User selects Google account
   - Google asks for permission

3. **Google authenticates user**
   - Verifies credentials
   - Returns authorization code

4. **Supabase exchanges code for tokens**
   - Sends code to Google with Client Secret
   - Receives access token and ID token
   - Creates user session in Supabase

5. **App receives user data**
   - User profile from Google
   - Supabase session tokens
   - Stored securely in app

6. **User is logged in**
   - Redirected to home screen
   - Can access protected features

---

## Security Best Practices

✅ **DO:**
- Store Client Secret only in Supabase (never in app code)
- Use HTTPS for all communications
- Verify redirect URIs carefully
- Use secure storage for tokens

❌ **DON'T:**
- Never commit Client Secret to Git
- Don't use Client Secret in mobile app
- Don't share OAuth credentials publicly
- Don't skip redirect URI validation

---

## Need Help?

If you're still stuck, please share:

1. **Your Client IDs** (sanitized, like: `123456-*****.apps.googleusercontent.com`)
2. **Error messages** from Flutter console
3. **Screenshots** of Supabase Google provider settings
4. **Screenshots** of Google Cloud Console OAuth client settings

I can then provide specific guidance for your setup!

---

**Created**: February 14, 2026  
**Last Updated**: February 14, 2026  
**Status**: Ready for configuration
