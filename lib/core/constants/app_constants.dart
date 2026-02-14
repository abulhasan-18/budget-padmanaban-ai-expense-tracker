class AppConstants {
  // App Info
  static const String appName = 'Budget Padmanaban';
  static const String appVersion = '1.0.0';

  // Supabase Configuration
  static const String supabaseUrl = 'https://zgyyilqfjhuomubmmkwa.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneXlpbHFmamh1b211Ym1ta3dhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEwMDAxMjIsImV4cCI6MjA4NjU3NjEyMn0.rhDid0f3AtLkTY-0wP88B24-CYE01f68jX6tmzWw38U';

  // Database Tables
  static const String usersTable = 'users';
  static const String expensesTable = 'expenses';
  static const String categoriesTable = 'categories';
  static const String budgetsTable = 'budgets';
  static const String receiptsTable = 'receipts';

  // Storage Buckets
  static const String receiptsBucket = 'receipts';

  // Local Storage Keys
  static const String onboardingKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String currencyKey = 'currency';

  // Expense Categories
  static const List<String> defaultCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Groceries',
    'Personal Care',
    'Subscriptions',
    'Others',
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking',
    'Wallet',
  ];

  // Currencies
  static const Map<String, String> currencies = {
    'INR': '₹',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
  };

  // Budget Alert Thresholds
  static const double warningThreshold = 0.8; // 80%
  static const double dangerThreshold = 1.0; // 100%

  // Pagination
  static const int itemsPerPage = 20;

  // Date Formats
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String displayTimeFormat = 'hh:mm a';
}
