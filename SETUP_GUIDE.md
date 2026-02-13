# Budget Padmanaban - Complete Setup Guide

## Project Overview

**Budget Padmanaban** is an AI-Powered Expense & Budget Tracker built with Flutter, Supabase, and AI capabilities.

### Features Implemented

#### Phase 1: Core Setup (COMPLETED)
- ✅ Project structure and dependencies
- ✅ Custom app logo widget
- ✅ Animated splash screen
- ✅ Complete authentication module
  - Email/Password sign in
  - Email/Password sign up
  - Forgot password functionality
  - Google Sign-In integration (needs configuration)
- ✅ Supabase integration setup
- ✅ State management with Riverpod
- ✅ Modern UI theme with Google Fonts

#### Phase 2: Features (TO BE IMPLEMENTED)
- ⏳ User Profile module
- ⏳ Expense Tracking module
- ⏳ Receipt Upload + AI OCR
- ⏳ AI Auto-Categorization
- ⏳ Analytics Dashboard
- ⏳ Budget Management
- ⏳ Offline Sync

---

## Step-by-Step Setup Instructions

### 1. Install Prerequisites

Ensure you have the following installed:
- **Flutter SDK 3.10.4+**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **Xcode** for mobile development
- **Git** for version control

Verify installation:
```bash
flutter doctor
```

### 2. Clone and Setup Project

```bash
cd budget_padmanaban
flutter pub get
```

### 3. Create Supabase Project

1. Go to [Supabase](https://supabase.com) and create an account
2. Click "New Project"
3. Fill in:
   - Project name: `budget-padmanaban` (or your choice)
   - Database password: (save this securely)
   - Region: Choose closest to you
4. Wait for project creation (~2 minutes)

### 4. Get Supabase Credentials

1. In your Supabase project dashboard
2. Go to **Settings** → **API**
3. Copy:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **Project API Key** (anon public key)

### 5. Configure App with Supabase Credentials

Open `lib/core/constants/app_constants.dart` and update:

```dart
// Replace these with your actual Supabase credentials
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

### 6. Setup Supabase Database Tables

Go to **SQL Editor** in Supabase dashboard and run this script:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT,
  avatar_url TEXT,
  currency TEXT DEFAULT 'INR',
  monthly_income DECIMAL(10,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Expenses table
CREATE TABLE public.expenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  category TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  notes TEXT,
  receipt_url TEXT,
  merchant TEXT,
  is_recurring BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Categories table (for custom categories)
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users NOT NULL,
  name TEXT NOT NULL,
  color TEXT,
  icon TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, name)
);

-- Budgets table
CREATE TABLE public.budgets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users NOT NULL,
  category TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  period TEXT DEFAULT 'monthly',
  start_date DATE NOT NULL,
  end_date DATE,
  alert_threshold DECIMAL(3,2) DEFAULT 0.8,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, category, period, start_date)
);

-- Receipts metadata table
CREATE TABLE public.receipts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  expense_id UUID REFERENCES public.expenses,
  user_id UUID REFERENCES public.users NOT NULL,
  file_path TEXT NOT NULL,
  extracted_data JSONB,
  processing_status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.receipts ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- RLS Policies for expenses table
CREATE POLICY "Users can view own expenses" ON public.expenses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses" ON public.expenses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses" ON public.expenses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses" ON public.expenses
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for categories table
CREATE POLICY "Users can manage own categories" ON public.categories
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for budgets table
CREATE POLICY "Users can manage own budgets" ON public.budgets
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for receipts table
CREATE POLICY "Users can manage own receipts" ON public.receipts
  FOR ALL USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_expenses_user_id ON public.expenses(user_id);
CREATE INDEX idx_expenses_date ON public.expenses(date DESC);
CREATE INDEX idx_expenses_category ON public.expenses(category);
CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_receipts_user_id ON public.receipts(user_id);

-- Function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for auto-updating updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON public.expenses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_receipts_updated_at BEFORE UPDATE ON public.receipts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 7. Setup Storage Bucket for Receipts

1. Go to **Storage** in Supabase dashboard
2. Click **New Bucket**
3. Name it: `receipts`
4. Set it to **Private** (authenticated users only)
5. Click **Create Bucket**

Now add storage policies. Go to **SQL Editor** and run:

```sql
-- Allow users to upload their own receipts
CREATE POLICY "Users can upload own receipts"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Allow users to view their own receipts
CREATE POLICY "Users can view own receipts"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Allow users to delete their own receipts
CREATE POLICY "Users can delete own receipts"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

### 8. Enable Google Sign-In (Optional)

1. In Supabase dashboard, go to **Authentication** → **Providers**
2. Find **Google** and click to configure
3. Follow [this guide](https://supabase.com/docs/guides/auth/social-login/auth-google)
4. You'll need:
   - Google Cloud Console project
   - OAuth 2.0 credentials
   - Add authorized redirect URIs

### 9. Run the App

```bash
# For Android
flutter run

# For iOS (Mac only)
flutter run -d ios

# For Web
flutter run -d chrome
```

### 10. Test the Authentication

1. App will open with animated splash screen
2. After 2.5 seconds, navigates to Login screen
3. Click "Sign Up" to create a new account
4. Fill in name, email, password
5. Click "Create Account"
6. You'll be redirected back to login
7. Sign in with your credentials
8. (Currently will show placeholder home screen - to be implemented)

---

## Current Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # App configuration
│   ├── theme/
│   │   └── app_theme.dart             # Theme and colors
│   ├── utils/
│   │   └── icon_generator.dart        # Icon generation utility
│   └── widgets/
│       └── app_logo.dart              # Reusable logo widget
├── features/
│   └── auth/
│       ├── models/                     # (Future: auth-related models)
│       ├── providers/
│       │   ├── auth_service.dart      # Supabase auth service
│       │   └── auth_provider.dart     # Riverpod state management
│       ├── screens/
│       │   ├── splash_screen.dart     # Animated splash
│       │   ├── login_screen.dart      # Login UI
│       │   ├── signup_screen.dart     # Sign up UI
│       │   └── forgot_password_screen.dart  # Password reset
│       └── widgets/                    # (Future: auth widgets)
├── models/
│   ├── user_profile.dart              # User profile model
│   └── expense.dart                   # Expense model
├── services/
│   └── supabase_service.dart          # Supabase client setup
└── main.dart                          # App entry point
```

---

## What's Next?

The next phases to implement:

### Phase 2A: User Profile Module
- Profile screen with editable fields
- Currency selection
- Monthly income setting
- Avatar upload
- Settings page

### Phase 2B: Expense Tracking Module
- Home dashboard
- Add expense form
- Expense list with filters
- Expense detail view
- Edit/delete functionality
- Quick add expense FAB

### Phase 2C: Receipt Upload + AI
- Camera integration
- Image picker
- Upload to Supabase Storage
- Google ML Kit OCR integration
- Extract merchant, amount, date
- Review before saving UI

### Phase 2D: AI Insights
- Monthly spending summary
- Category-wise breakdown
- Spending trends
- Smart suggestions
- Unusual spending alerts

### Phase 2E: Analytics Dashboard
- Charts with FL Chart
- Category pie chart
- Monthly trend line
- Top merchants
- Budget progress bars

### Phase 2F: Budget Management
- Set category budgets
- Budget alerts (80%, 100%)
- Budget vs actual comparison
- Budget recommendations

### Phase 2G: Offline Mode (Advanced)
- Hive local database
- Sync queue
- Offline indicator
- Background sync

---

## Troubleshooting

### Issue: Supabase connection fails
- Check your URL and API key in `app_constants.dart`
- Ensure you're using the **anon/public** key, not the service role key
- Check internet connection

### Issue: Can't sign up
- Check Supabase dashboard → Authentication → Email Auth is enabled
- Check database tables were created successfully
- Check RLS policies are in place

### Issue: App doesn't build
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Logo not showing
- The logo is a Flutter widget, not an image file
- Check `lib/core/widgets/app_logo.dart` exists
- Restart the app

---

## Notes for Recruiter/Interviewer

This project demonstrates:

1. **Clean Architecture**: Feature-based folder structure
2. **State Management**: Riverpod for reactive state
3. **Backend Integration**: Supabase for Auth, DB, Storage
4. **Modern UI**: Material Design 3, Google Fonts, animations
5. **Security**: Row Level Security policies in database
6. **Scalability**: Modular design for easy feature additions
7. **Production-Ready**: Error handling, validation, loading states

**Tech Stack Highlights**:
- Flutter 3.10.4+
- Supabase (PostgreSQL + Auth + Storage)
- Riverpod for state management
- Google ML Kit for AI/OCR (next phase)
- FL Chart for analytics (next phase)

---

## License

MIT License - Free to use and modify
