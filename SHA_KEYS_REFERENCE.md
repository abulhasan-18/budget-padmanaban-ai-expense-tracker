# SHA Keys Quick Reference - Budget Padmanaban

## Package Name
```
com.abulhasan.budget_padmanaban
```

---

## Debug Keys (Development)

### SHA-1
```
49:46:58:8F:A7:20:12:BD:B2:C3:CF:1C:52:A5:BC:B0:00:FB:43:40
```

### SHA-256
```
B5:98:CC:3A:44:DF:E7:E7:F1:E4:F5:D8:4C:21:65:4E:19:FF:46:F1:CD:C2:F6:77:22:99:77:80:FF:90:1C:BC
```

---

## Release Keys (Production)

### SHA-1
```
BF:29:4E:16:17:AE:4C:ED:94:4C:94:04:A7:1F:3D:D3:E8:0C:E0:06
```

### SHA-256
```
EA:B6:FD:93:1F:E1:A4:08:F0:D7:4B:3C:1C:37:DE:05:90:E8:D2:49:27:CD:CF:41:22:2C:5E:B2:57:4E:D8:6F
```

---

## Keystore Credentials

**Location**: `android/app/upload-keystore.jks`
**Alias**: `upload`
**Store Password**: `Budget@Padmanaban2026`
**Key Password**: `Budget@Padmanaban2026`

---

## Quick Commands

### Build Release APK
```bash
flutter build apk --release
```

### Build Release App Bundle
```bash
flutter build appbundle --release
```

### View Keystore Info
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload -storepass "Budget@Padmanaban2026"
```

---

## Google Cloud Console Setup

1. Go to: https://console.cloud.google.com/apis/credentials
2. Create OAuth client ID → Android
3. Package: `com.abulhasan.budget_padmanaban`
4. Add **both** SHA-1 fingerprints (debug AND release)

---

## Firebase Setup

1. Go to: https://console.firebase.google.com/
2. Project Settings → Your apps → Android
3. Add **both** SHA-1 fingerprints (debug AND release)

---

## Play Store Upload

1. Build: `flutter build appbundle --release`
2. File location: `build/app/outputs/bundle/release/app-release.aab`
3. Upload to: https://play.google.com/console/

---

**IMPORTANT**: Backup your keystore file immediately!
See `KEYSTORE_INFO.md` for full details.
