# 🚀 Next Steps Action Plan

**Status**: Ready for Supabase Database & Google Sign-In Configuration

---

## ✅ What's Been Completed

1. **All code committed and pushed to GitHub** (Commit: 038c8e8)
2. **Android & iOS configurations complete**
3. **Authentication module built**
4. **Security implemented**
5. **Release keystore created with SHA keys**

---

## 🎯 Critical Next Steps (Do These Now!)

### Step 1: Create Supabase Database Tables ⚠️ REQUIRED

**Time Required**: 5 minutes

**Why**: Your app cannot store any data until the database tables exist.

**Action**:

1. **Open Supabase SQL Editor**:
   - Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/sql/new

2. **Copy and paste this entire SQL script** (from `SUPABASE_CONFIGURED.md` lines 46-178):

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

-- Categories table
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

-- Receipts table
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

-- RLS Policies for users
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- RLS Policies for expenses
CREATE POLICY "Users can view own expenses" ON public.expenses
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own expenses" ON public.expenses
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own expenses" ON public.expenses
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own expenses" ON public.expenses
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for categories
CREATE POLICY "Users can manage own categories" ON public.categories
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for budgets
CREATE POLICY "Users can manage own budgets" ON public.budgets
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for receipts
CREATE POLICY "Users can manage own receipts" ON public.receipts
  FOR ALL USING (auth.uid() = user_id);

-- Create indexes
CREATE INDEX idx_expenses_user_id ON public.expenses(user_id);
CREATE INDEX idx_expenses_date ON public.expenses(date DESC);
CREATE INDEX idx_expenses_category ON public.expenses(category);
CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_receipts_user_id ON public.receipts(user_id);

-- Auto-update timestamp function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON public.expenses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_receipts_updated_at BEFORE UPDATE ON public.receipts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

3. **Click "RUN"** button (bottom right)

4. **Verify Success**:
   - You should see "Success. No rows returned"
   - Go to Table Editor: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/editor
   - You should see 5 new tables: users, expenses, categories, budgets, receipts

---

### Step 2: Create Storage Bucket for Receipts

**Time Required**: 2 minutes

**Why**: Receipt images need a place to be stored.

**Action**:

1. **Go to Storage**:
   - https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/storage/buckets

2. **Click "New Bucket"**

3. **Configure**:
   - Name: `receipts`
   - Public: **NO** (keep it private)
   - Click "Create bucket"

4. **Set Storage Policies** - Go back to SQL Editor and run:

```sql
-- Storage policies for receipts bucket
CREATE POLICY "Users can upload own receipts"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can view own receipts"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete own receipts"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'receipts' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

---

### Step 3: Verify Email Authentication is Enabled

**Time Required**: 1 minute

**Action**:

1. Go to: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
2. Ensure **Email** provider is **Enabled** (should already be enabled by default)

---

## 🔍 Step 4: Check Your Google OAuth Client IDs

**Status**: You have iOS and Android client IDs in the `secret` folder

**What You Have**:
- ✅ iOS Client ID: `100365260400-3pq13g933obfhbceaugcc2n5mbei396v.apps.googleusercontent.com`
- ✅ Android/Desktop Client ID: `100365260400-lgdubqv1bgretfhd4lvrog1uq2cho015.apps.googleusercontent.com`

**What's Missing**: 
- ❌ **Web OAuth Client ID** (required for Supabase Google Sign-In)

### Create Web OAuth Client ID

**Action**:

1. **Go to Google Cloud Console**:
   - https://console.cloud.google.com/apis/credentials?project=budget-padmanaban

2. **Click "Create Credentials" → "OAuth client ID"**

3. **Configure**:
   - Application type: **Web application**
   - Name: `Budget Padmanaban Web Client`
   
4. **Authorized JavaScript origins**:
   ```
   https://zgyyilqfjhuomubmmkwa.supabase.co
   ```

5. **Authorized redirect URIs**:
   ```
   https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback
   ```

6. **Click "CREATE"**

7. **Download the JSON** or copy:
   - Client ID (looks like: `xxxxx.apps.googleusercontent.com`)
   - Client Secret (looks like: `GOCSPX-xxxxx`)

---

## 🔗 Step 5: Configure Google Sign-In in Supabase

**Time Required**: 3 minutes

**Action**:

1. **Go to Supabase Authentication Providers**:
   - https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers

2. **Find "Google" provider**:
   - Click on it to expand

3. **Enable Google**:
   - Toggle: **Enabled** = ON

4. **Enter Web Client Details**:
   - **Client ID (for OAuth)**: Paste your Web Client ID
   - **Client Secret (for OAuth)**: Paste your Web Client Secret

5. **Copy the Redirect URL**:
   - Supabase will show you: `https://zgyyilqfjhuomubmmkwa.supabase.co/auth/v1/callback`
   - Make sure this is added to your Web OAuth client (you did this in Step 4.5)

6. **Add Android & iOS Client IDs**:
   - In the "Authorized Client IDs" section, add:
   ```
   100365260400-3pq13g933obfhbceaugcc2n5mbei396v.apps.googleusercontent.com
   100365260400-lgdubqv1bgretfhd4lvrog1uq2cho015.apps.googleusercontent.com
   ```

7. **Click "Save"**

---

## 📱 Step 6: Update App Configuration

**Time Required**: 2 minutes

**Action**: Update `lib/core/constants/app_constants.dart` to add Google Web Client ID

**I can do this for you - just provide me with your Web Client ID after you create it.**

---

## 🧪 Step 7: Test the Application

**Time Required**: 5-10 minutes

**Prerequisites**: 
- ✅ Supabase database tables created (Step 1)
- ✅ Storage bucket created (Step 2)
- ✅ Email auth enabled (Step 3)
- ✅ Google Sign-In configured (Steps 4-6)

**Action**:

```bash
flutter clean
flutter pub get
flutter run
```

**What to Test**:

1. **App Launch**:
   - ✅ Splash screen appears with animated logo
   - ✅ After 2.5 seconds, transitions to Login screen

2. **Sign Up Flow**:
   - ✅ Click "Sign Up Here"
   - ✅ Fill in: Name, Email, Password
   - ✅ Click "Sign Up"
   - ✅ Check your email for confirmation (if email confirmation is enabled)
   - ✅ Success message appears

3. **Login Flow**:
   - ✅ Enter email and password
   - ✅ Click "Sign In"
   - ✅ You should be logged in successfully

4. **Google Sign-In** (after Step 6 is complete):
   - ✅ Click "Sign in with Google"
   - ✅ Google account picker appears
   - ✅ Select account
   - ✅ You should be logged in successfully

5. **Forgot Password**:
   - ✅ Click "Forgot Password?"
   - ✅ Enter email
   - ✅ Check email for reset link

---

## 📊 Progress Checklist

### Database Setup
- [ ] Supabase database tables created (Step 1)
- [ ] Storage bucket created (Step 2)
- [ ] Storage policies set (Step 2)
- [ ] Email auth verified (Step 3)

### Google Sign-In Setup
- [x] iOS Client ID created (already done)
- [x] Android Client ID created (already done)
- [ ] Web OAuth Client ID created (Step 4)
- [ ] Web OAuth Client Secret obtained (Step 4)
- [ ] Google provider enabled in Supabase (Step 5)
- [ ] Web Client credentials added to Supabase (Step 5)
- [ ] Android/iOS Client IDs authorized in Supabase (Step 5)
- [ ] App configuration updated with Web Client ID (Step 6)

### Testing
- [ ] App builds successfully (Step 7)
- [ ] Splash screen works (Step 7)
- [ ] Sign up works (Step 7)
- [ ] Login works (Step 7)
- [ ] Google Sign-In works (Step 7)
- [ ] Forgot password works (Step 7)

---

## 🚨 Common Issues & Solutions

### Issue: "Table does not exist" error
**Solution**: Run the SQL script from Step 1

### Issue: "Invalid API key" error
**Solution**: Check credentials in `lib/core/constants/app_constants.dart`

### Issue: Google Sign-In button doesn't work
**Solution**: Complete Steps 4-6 (Web OAuth Client + Supabase configuration)

### Issue: "Row Level Security policy violation"
**Solution**: Make sure RLS policies were created in Step 1

### Issue: Cannot upload receipts
**Solution**: Create storage bucket and policies (Step 2)

---

## 🎯 What Happens After Testing

Once testing is complete and everything works, we can proceed with:

### Phase 1: User Profile Module
- Profile screen
- Edit profile functionality
- Currency selection
- Monthly income setting

### Phase 2: Home Dashboard
- Total expenses display
- Recent expenses list
- Quick add expense button
- Monthly summary

### Phase 3: Expense Management
- Add expense screen
- Expense list with filters
- Edit/Delete expenses
- Category management

### Phase 4: Receipt Upload & OCR
- Camera integration
- Image upload
- Google ML Kit OCR
- AI data extraction

### Phase 5: Analytics & Charts
- Spending charts
- Category breakdown
- Monthly trends
- Budget tracking

---

## 📞 Need Help?

If you encounter any issues:

1. Check the error message in the Flutter debug console
2. Check Supabase logs: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/logs/explorer
3. Verify all checklist items above are complete
4. Ask me for help with specific error messages

---

## 🔗 Quick Links

**Supabase Dashboard**:
- Main: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa
- SQL Editor: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/sql/new
- Table Editor: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/editor
- Storage: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/storage/buckets
- Auth Providers: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/auth/providers
- Logs: https://supabase.com/dashboard/project/zgyyilqfjhuomubmmkwa/logs/explorer

**Google Cloud Console**:
- Credentials: https://console.cloud.google.com/apis/credentials?project=budget-padmanaban

**GitHub Repository**:
- https://github.com/abulhasan-18/budget-padmanaban-ai-expense-tracker

---

## ⏱️ Time Estimate

**Total Time to Complete All Steps**: 15-20 minutes

- Step 1 (Database): 5 minutes
- Step 2 (Storage): 2 minutes
- Step 3 (Email Auth): 1 minute
- Step 4 (Web OAuth): 3 minutes
- Step 5 (Supabase Google): 3 minutes
- Step 6 (App Config): 2 minutes
- Step 7 (Testing): 5-10 minutes

---

## ✅ Ready to Start?

**START HERE**: Step 1 - Create Supabase Database Tables

Once you complete Step 1, you can immediately test sign up and login (without Google Sign-In).

Then proceed with Steps 4-6 to enable Google Sign-In.

---

**Last Updated**: Feb 14, 2026  
**Project**: Budget Padmanaban - AI-Powered Expense Tracker  
**Status**: Ready for Database Setup
