# Supabase Google Sign-In - Quick Setup Steps

## 🎯 What You Need

From your "client folder", you should have:
1. **Web Client ID** (ends with `.apps.googleusercontent.com`)
2. **Web Client Secret** (starts with `GOCSPX-`)
3. Android Client ID (optional, but good to have)
4. iOS Client ID (optional, but good to have)

---

## 📋 Step-by-Step Setup

### Step 1: Open Supabase Authentication

1. Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa

2. Click **Authentication** in left sidebar (shield icon)

3. Click **Providers** tab at the top

---

### Step 2: Find Google Provider

1. Scroll down the list of providers

2. Find **Google** (has the Google logo)

3. Click on it to expand

---

### Step 3: Enable Google

1. You'll see a toggle switch at the top

2. Click it to turn it **ON** (will turn green)

---

### Step 4: Fill in the Form

You'll see several fields. Here's what to put in each:

#### **Authorized Client IDs**
```
Paste your Web Client ID here
Example: 123456789-abcd1234xyz.apps.googleusercontent.com
```

#### **Client ID (for OAuth)**
```
Paste your Web Client ID here (same as above)
Example: 123456789-abcd1234xyz.apps.googleusercontent.com
```

#### **Client Secret (for OAuth)**
```
Paste your Web Client Secret here
Example: GOCSPX-abcdefghijklmnopqrstuvwxyz
```

#### **Redirect URL**
```
This is pre-filled - DO NOT CHANGE IT!
Should be: https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

**COPY THIS URL** - you need it for the next step!

---

### Step 5: Save in Supabase

1. Scroll to the bottom

2. Click the **Save** button

3. You should see a success message

---

### Step 6: Update Google Cloud Console

Now you need to tell Google about Supabase's redirect URL.

1. Go to: https://console.cloud.google.com/apis/credentials

2. Find your **OAuth 2.0 Client IDs**

3. Click on your **Web application** client (NOT Android or iOS)

4. Scroll to **Authorized redirect URIs**

5. Click **+ ADD URI**

6. Paste: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`

7. Click **SAVE** at the bottom

---

### Step 7: Done!

That's it! Google Sign-In is now configured in Supabase.

---

## 🔍 How to Find Your Client IDs

### In Google Cloud Console:

**For Web Client ID and Secret:**

1. Go to: https://console.cloud.google.com/apis/credentials

2. Look for **OAuth 2.0 Client IDs** section

3. Find the one with **Type: Web application**

4. Click on it

5. You'll see:
   - **Client ID**: Long string ending in `.apps.googleusercontent.com`
   - **Client secret**: String starting with `GOCSPX-`

6. Click the **copy icons** to copy them

**For Android Client ID:**

1. Same page, same section

2. Find the one with **Type: Android**

3. Click on it

4. Copy the **Client ID**

**For iOS Client ID:**

1. Same page, same section

2. Find the one with **Type: iOS**

3. Click on it

4. Copy the **Client ID**

---

## ✅ Verification Checklist

After completing setup, verify:

### In Supabase:
- [ ] Google provider shows **Enabled** (green toggle)
- [ ] Web Client ID is filled in
- [ ] Client Secret is filled in
- [ ] Redirect URL is: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`
- [ ] Changes are saved (no unsaved changes warning)

### In Google Cloud Console:
- [ ] Web application OAuth client exists
- [ ] Has authorized redirect URI: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`
- [ ] Android OAuth client has your SHA-1 keys
- [ ] iOS OAuth client has your Bundle ID

---

## 🧪 Test Your Setup

### Quick Test:

1. In Supabase Dashboard, go to: **Authentication** → **Users**

2. Click **Invite user** (just to test, you can delete later)

3. OR better yet, run your app and try signing in!

### In Your App:

1. Run: `flutter run`

2. Wait for app to load

3. Tap **"Sign in with Google"** button

4. Google Sign-In sheet should appear

5. Select a Google account

6. Grant permissions

7. Should redirect back to app

8. Check Supabase Dashboard → Authentication → Users

9. You should see your account listed!

---

## 🚨 Common Mistakes

### ❌ WRONG: Using Android/iOS Client ID in Supabase
```
DON'T USE: 123456789-android.apps.googleusercontent.com
DON'T USE: 123456789-ios.apps.googleusercontent.com
```

### ✅ CORRECT: Using Web Client ID in Supabase
```
USE THIS: 123456789-web123.apps.googleusercontent.com
```

---

### ❌ WRONG: Forgetting to add redirect URI to Google
```
Error: "Redirect URI mismatch"
```

### ✅ CORRECT: Adding Supabase callback to Google Cloud Console
```
Authorized redirect URIs:
  - https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
```

---

### ❌ WRONG: Extra spaces in Client ID/Secret
```
" 123456789-abc.apps.googleusercontent.com"  ← Space at start
"123456789-abc.apps.googleusercontent.com "  ← Space at end
```

### ✅ CORRECT: Clean copy-paste
```
"123456789-abc.apps.googleusercontent.com"
```

---

## 🆘 Troubleshooting

### "I don't see my Client IDs"

1. Make sure you're in the correct Google Cloud project
2. Check if you actually created OAuth credentials
3. Go to: APIs & Services → Credentials
4. Look for "OAuth 2.0 Client IDs" section

### "I can't find the Client Secret"

1. Go to Google Cloud Console → Credentials
2. Click on your **Web application** OAuth client
3. Look for **Client secret** field
4. Click the **copy icon** next to it
5. If you can't see it, you may need to reset it

### "Redirect URI mismatch error"

This means the callback URL is not added to Google Cloud Console.

**Fix:**
1. Copy this exactly: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`
2. Go to Google Cloud Console → Credentials
3. Click on **Web application** OAuth client
4. Scroll to **Authorized redirect URIs**
5. Click **+ ADD URI**
6. Paste the URL
7. Click **SAVE**
8. Wait 1-2 minutes for changes to propagate
9. Try again

### "Google Sign-In is not working in my app"

1. Check if you ran `flutter clean && flutter pub get`
2. Verify app constants have the Web Client ID
3. Check Flutter console for specific error messages
4. Make sure device has internet connection
5. Try signing in with a different Google account

---

## 📝 Summary

**What you did:**
1. ✅ Enabled Google provider in Supabase
2. ✅ Added Web Client ID to Supabase
3. ✅ Added Web Client Secret to Supabase
4. ✅ Added Supabase callback URL to Google Cloud Console

**What happens now:**
- Users can sign in with Google
- Supabase handles all OAuth flow
- User data is stored in Supabase
- Your app gets authenticated user

**Next steps:**
1. Test Google Sign-In in your app
2. Handle user data after sign-in
3. Build your app features!

---

## 🔗 Important Links

**Supabase:**
- Dashboard: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa
- Auth Providers: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
- Users: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/users

**Google Cloud:**
- Console: https://console.cloud.google.com/
- Credentials: https://console.cloud.google.com/apis/credentials

**Documentation:**
- Supabase Google Auth: https://supabase.com/docs/guides/auth/social-login/auth-google
- Google OAuth: https://developers.google.com/identity/protocols/oauth2

---

**Need more help?** Share your:
1. Client IDs (first 5 digits only, like: `12345-*****`)
2. Error messages from app
3. Screenshots of Supabase settings

I'll help you debug! 🚀
