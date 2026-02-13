class AppConstants {
  // App Info
  static const String appName = 'BudgetTracker';
  static const String appVersion = '1.0.0';

  // Supabase - IMPORTANT: Replace with your actual Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

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
