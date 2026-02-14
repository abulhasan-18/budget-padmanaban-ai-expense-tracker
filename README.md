# Budget Padmanaban

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](https://github.com/abulhasan-18/budget-padmanaban-ai-expense-tracker)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

An AI-Powered Expense & Budget Tracker built with Flutter, Supabase, and AI capabilities.

> 🚀 A modern mobile app for tracking expenses, scanning receipts with OCR, and getting AI-powered insights about your spending habits.

## Features

- **Authentication**: Email/Password + Google Sign-In
- **Expense Tracking**: Quick expense entry with category auto-suggestion
- **Receipt Upload**: AI-powered OCR to extract expense details from receipts
- **AI Insights**: Monthly spending summaries and personalized recommendations
- **Analytics Dashboard**: Visual spending breakdown with charts
- **Budget Management**: Set budgets by category with smart alerts
- **Offline Support**: Works offline and syncs when online

## Tech Stack

- **Frontend**: Flutter (Android & iOS only)
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **State Management**: Riverpod
- **Secure Storage**: Flutter Secure Storage (encrypted credentials)
- **AI/ML**: Google ML Kit for OCR
- **Charts**: FL Chart
- **Local Storage**: Hive + Shared Preferences

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.10.4 or higher)
- Android Studio / Xcode
- Supabase account

### 2. Clone and Install

```bash
git clone <repository-url>
cd budget_padmanaban
flutter pub get
```

### 3. Supabase Configuration

1. Create a new project on [Supabase](https://supabase.com)
2. Get your project URL and anon key from Project Settings > API
3. Update `lib/core/constants/app_constants.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

4. Run the database migration scripts (see Database Setup below)

### 4. Database Setup

Create the following tables in your Supabase project:

```sql
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

-- Budgets table
CREATE TABLE public.budgets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users NOT NULL,
  category TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  period TEXT DEFAULT 'monthly',
  start_date DATE NOT NULL,
  end_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, category, period)
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own expenses" ON public.expenses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses" ON public.expenses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses" ON public.expenses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses" ON public.expenses
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own budgets" ON public.budgets
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own budgets" ON public.budgets
  FOR ALL USING (auth.uid() = user_id);
```

### 5. Storage Bucket Setup

1. Go to Storage in Supabase dashboard
2. Create a new bucket named `receipts`
3. Make it private (only authenticated users can access)
4. Add the following RLS policy:

```sql
CREATE POLICY "Users can upload own receipts"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'receipts' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view own receipts"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'receipts' AND auth.uid()::text = (storage.foldername(name))[1]);
```

### 6. Google Sign-In Setup (Optional)

1. Follow [this guide](https://supabase.com/docs/guides/auth/social-login/auth-google) for Google OAuth
2. Add your Google Client ID in Supabase Auth settings

### 7. Generate App Icon

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### 8. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants and configuration
│   ├── theme/          # App theme and colors
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets (AppLogo, etc.)
├── features/
│   ├── auth/           # Authentication (Login, Signup, Splash)
│   ├── expenses/       # Expense tracking
│   ├── receipts/       # Receipt upload and AI extraction
│   ├── insights/       # AI insights and summaries
│   ├── analytics/      # Charts and analytics
│   ├── budget/         # Budget management
│   └── profile/        # User profile
├── models/             # Data models
├── services/           # API services (Supabase, AI, etc.)
└── main.dart           # App entry point
```

## Features Roadmap

- [x] Project setup and configuration
- [x] App logo and splash screen
- [ ] Authentication module
- [ ] Expense tracking
- [ ] Receipt OCR
- [ ] AI categorization
- [ ] Analytics dashboard
- [ ] Budget alerts
- [ ] Offline sync

## Contributing

This is a portfolio project. Feel free to fork and customize!

## Author

**Mohammed Abulhasan** - [GitHub](https://github.com/abulhasan-18)

## Repository

[https://github.com/abulhasan-18/budget-padmanaban-ai-expense-tracker](https://github.com/abulhasan-18/budget-padmanaban-ai-expense-tracker)

## License

MIT License - See [LICENSE](LICENSE) file for details
