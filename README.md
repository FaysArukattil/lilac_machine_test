# Expenzia – Expense Management App

A Flutter expense management mobile application built for the **Lilac Infotech Flutter Developer Machine Test**.
The UI follows the provided Figma design, and all data is stored locally in **SQLite**.

> **Platforms:** Android and iOS. The web build is not supported because `sqflite` does not run on Flutter web.

---

## Table of contents

1. [Features](#features)
2. [Screens](#screens)
3. [Screenshots](#screenshots)
4. [Tech stack and dependencies](#tech-stack-and-dependencies)
5. [Architecture and project structure](#architecture-and-project-structure)
6. [Database design](#database-design)
7. [Validation and error handling](#validation-and-error-handling)
8. [Setup and run instructions](#setup-and-run-instructions)
9. [How the requirements are met](#how-the-requirements-are-met)
10. [Design decisions and assumptions](#design-decisions-and-assumptions)
11. [Known issues and incomplete features](#known-issues-and-incomplete-features)
12. [Manual test checklist](#manual-test-checklist)

---

## Features

### Expense management
- View all transactions with title, category, description (if any), date and amount.
- Add a new transaction (income or expense).
- Edit an existing transaction (tap a row, or swipe left and tap the edit button).
- Delete a transaction with a **confirmation dialog** (swipe left and tap the delete button).
- Total balance, total income and total expenses are shown on the home screen.
- Daily average and weekly expense summaries.
- The list and all totals update automatically after every add, edit or delete.
- Empty states are shown when there is no data.

### Credit (bills and subscriptions)
- Save upcoming payments with credit type, recipient, amount, due date and plan type (Monthly or One-Time).
- Saved list shows "Due Today" (highlighted) or "Due On dd/MM/yy".
- Swipe left to delete, with confirmation.

### Profile
- Editable display name.
- Profile photo from the gallery or camera, with the option to remove it.
- **Clear Storage** wipes all transactions, credits, name and photo (with confirmation).

### Other
- Splash screen, then an onboarding screen that is shown **only on the first launch**.
- The user's name is asked once, during onboarding.
- Persistent data: everything survives closing and reopening the app.

---

## Screens

| # | Screen | File |
|---|--------|------|
| 1 | Splash | `lib/views/splash_screen.dart` |
| 2 | Onboarding | `lib/views/onboarding_screen.dart` |
| 3 | Home (balance card, stats, recent transactions) | `lib/views/home_screen.dart` |
| 4 | Transaction History (swipe to edit or delete) | `lib/views/transaction_history_screen.dart` |
| 5 | Add Transaction | `lib/views/add_transaction_screen.dart` |
| 6 | Edit Transaction | `lib/views/edit_transaction_screen.dart` |
| 7 | Credit | `lib/views/credit_screen.dart` |
| 8 | Profile | `lib/views/profile_screen.dart` |

`lib/views/main_screen.dart` is the shell that holds the bottom navigation bar (Home, History, Credit, Profile) and the centre **+** button.

> Note on Figma frame names: in the design file, the frame called "Transaction" is the add form and the frame called "Add Expense" is the transaction history list. The files are named after what each screen actually does.

---

## Screenshots

> Add your screenshots to a `screenshots/` folder and keep the file names below (or update the paths).

| Splash | Onboarding | Home |
|:--:|:--:|:--:|
| ![Splash](screenshots/01_splash.png) | ![Onboarding](screenshots/02_onboarding.png) | ![Home](screenshots/03_home.png) |

| History | Add transaction | Edit transaction |
|:--:|:--:|:--:|
| ![History](screenshots/04_history.png) | ![Add](screenshots/05_add.png) | ![Edit](screenshots/06_edit.png) |

| Credit | Profile | Delete confirmation |
|:--:|:--:|:--:|
| ![Credit](screenshots/07_credit.png) | ![Profile](screenshots/08_profile.png) | ![Delete](screenshots/09_delete_dialog.png) |

---

## Tech stack and dependencies

- **Flutter** and **Dart** (Dart SDK `^3.13.4`, see `pubspec.yaml`)
- **State management and navigation:** GetX
- **Local database:** SQLite through `sqflite`

| Package | Purpose |
|---------|---------|
| `get` | State management (controllers, `Obx`), navigation, dialogs, snackbars |
| `sqflite` | SQLite database (transactions and credits) |
| `path` | Building the database and image file paths |
| `path_provider` | App documents directory (profile photo storage) |
| `intl` | Currency (₹, Indian grouping) and date formatting |
| `shared_preferences` | Small settings: user name, profile photo file name, onboarding-seen flag |
| `flutter_slidable` | Swipe actions (edit and delete) on list rows |
| `image_picker` | Choosing the profile photo from the gallery or camera |
| `cupertino_icons` | Default icon font |

No prebuilt application templates were used. All code is written for this test.

---

## Architecture and project structure

The app follows an **MVC-style** structure that separates UI, models, and database logic.

```
lib/
├── main.dart                         # App entry, theme, controller registration
│
├── models/                           # M: data classes
│   ├── expense_model.dart            #    Transaction (toMap / fromMap)
│   └── credit_model.dart             #    Credit item (toMap / fromMap)
│
├── database/                         # SQLite access only (no UI code)
│   └── database_helper.dart          #    Singleton, table creation, migrations, CRUD
│
├── controllers/                      # C: state and business logic (GetX)
│   ├── expense_controller.dart       #    Lists, totals, CRUD calls, profile logic
│   └── nav_controller.dart           #    Bottom navigation tab index
│
├── views/                            # V: screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── main_screen.dart              #    Bottom nav shell
│   ├── home_screen.dart
│   ├── transaction_history_screen.dart
│   ├── add_transaction_screen.dart
│   ├── edit_transaction_screen.dart
│   ├── credit_screen.dart
│   ├── profile_screen.dart
│   └── widgets/                      #    Reusable widgets
│       ├── primary_header.dart       #      Teal top bar (title and back button)
│       ├── primary_button.dart
│       ├── app_text_field.dart       #      Labelled text field
│       ├── app_dropdown.dart         #      Labelled dropdown
│       ├── transaction_form.dart     #      Shared by Add and Edit screens
│       ├── total_card.dart           #      Balance / income / expense card
│       ├── expense_card.dart         #      One transaction row
│       ├── expense_tile.dart         #      Row + tap-to-edit + swipe actions
│       ├── empty_state.dart
│       ├── confirm_dialog.dart       #      Reusable delete confirmation
│       └── edit_name_dialog.dart
│
└── utils/
    ├── app_colors.dart               # Colours taken from Figma
    ├── app_styles.dart               # Text and input styles
    ├── app_categories.dart           # Expense and income category lists
    ├── app_keys.dart                 # SharedPreferences keys
    ├── formatters.dart               # Currency and date formatting
    ├── validators.dart               # Form validation rules
    └── snackbar_helper.dart          # Success and error snackbars
```

### Data flow

```
View (user action) → Controller → DatabaseHelper → SQLite
        ↑                 │
        └── Obx rebuilds ←┘  (controller reloads the observable list)
```

- Views never touch the database directly.
- After every add, edit or delete, the controller reloads the list from SQLite, so the list and the totals always reflect the stored data.

---

## Database design

**Database file:** `expenzia.db` (version 2)

### `transactions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER | Primary key, autoincrement |
| `title` | TEXT | Required |
| `amount` | REAL | Required, positive |
| `type` | TEXT | `income` or `expense` |
| `category` | TEXT | Required, default `Other` |
| `date` | TEXT | ISO 8601 string |
| `description` | TEXT | Optional (nullable) |

### `credits`

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER | Primary key, autoincrement |
| `credit_type` | TEXT | Subscriptions, Bills, Loan, Other |
| `to_name` | TEXT | Recipient |
| `amount` | REAL | Required, positive |
| `plan_type` | TEXT | Monthly or One-Time |
| `date` | TEXT | Due date, ISO 8601 string |

### Migrations
Version 1 → 2 adds the `category` and `description` columns with `ALTER TABLE`, so existing data is preserved on upgrade.

### CRUD operations
Create, read, update and delete for transactions, and create, read and delete for credits, are all implemented in `lib/database/database_helper.dart`.

---

## Validation and error handling

### Form validation

| Field | Rule | Message |
|-------|------|---------|
| Name / To | Required | "Name is required" |
| Amount | Required | "Amount is required" |
| Amount | Must be a number | "Enter a valid number" |
| Amount | Must be greater than 0 | "Amount must be greater than 0" |
| Date | Required | "Date is required" |
| Category | Always has a selected value | n/a |
| Description | Optional | n/a |

- The amount field only accepts digits and up to two decimal places.
- A record is **not** saved until all validations pass.

### Error handling
- Every database call in the controller is wrapped in `try/catch`.
- On failure the user sees an error snackbar, and the screen does not close, so the entered data is not lost.
- Profile photo and settings operations are also guarded.
- The onboarding image has a fallback icon if it cannot be loaded.

---

## Setup and run instructions

### Prerequisites
- Flutter SDK (stable channel, with Dart 3.13 or newer)
- Xcode with an iOS Simulator (macOS), or Android Studio with an emulator
- An editor such as VS Code, Android Studio or Antigravity

### Steps

```bash
# 1. Clone the repository
git clone <repository-url>
cd lilac_machine_test

# 2. Install dependencies
flutter pub get

# 3. Check your setup
flutter doctor

# 4. Run on a simulator or device (not Chrome)
flutter run
# or pick a device explicitly:
flutter devices
flutter run -d <device-id>
```

### iOS permissions (already configured)
`ios/Runner/Info.plist` contains the photo library and camera usage descriptions needed for the profile photo:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo access to set your profile picture.</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take your profile picture.</string>
```

The iOS Simulator has no camera. Use **Choose from gallery** there. The camera option works on a real device.

### Assets
The onboarding illustration is at `assets/images/asset_onboarding.png` and is registered in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

After changing assets or adding native plugins, do a full stop and restart (hot reload is not enough).

### Resetting the app during testing
- **Profile → Clear Storage** deletes transactions, credits, name and photo.
- To see the onboarding screen again, uninstall the app from the simulator or device and reinstall it.

---

## How the requirements are met

| Requirement | Where |
|-------------|-------|
| Display list of expenses with details | Home (recent) and History (all), showing title, category, description, date, amount |
| Add new expenses | Add Transaction screen (centre **+** button) |
| Edit existing expenses | Tap a row, or swipe left and tap the pencil, which opens Edit Transaction |
| Delete with confirmation | Swipe left and tap the bin, then a confirmation dialog (Cancel or Delete) |
| Display total expense amount | "Expenses" figure on the Home balance card (plus balance and income) |
| Auto-update list and total | Controller reloads from SQLite after every change, and the UI observes it with `Obx` |
| Empty state | Home, History and the Credit saved list |
| Expense details: title, amount, category, date, optional description | `ExpenseModel`, the `transactions` table and the shared form |
| Form validation | `utils/validators.dart` plus `Form` and `TextFormField` validators |
| SQLite CRUD and persistence | `database/database_helper.dart` |
| Basic DB error handling | `try/catch` in every controller method, with a user-facing snackbar |
| Clean project structure, UI/model/DB separated | See [project structure](#architecture-and-project-structure) |
| Reusable widgets | `views/widgets/` (form, tile, card, dialogs, fields) |
| Responsiveness | Flexible layouts, `FittedBox` for large amounts, scrollable forms, `SafeArea` |
| Navigation and state updates | GetX navigation and reactive controllers |

---

## Design decisions and assumptions

- **Category and description** are not in the Figma form, but they are required by the test brief, so they were added to the Add and Edit forms. Categories are chosen from a fixed list that depends on the transaction type (income or expense).
- **Transaction type** (Income or Expense) comes from the Figma design. Green `+` is income and red `-` is expense.
- **Currency:** the Figma home screen shows `$` while the other screens show `₹`. The app uses `₹` everywhere for consistency.
- **Credit amount:** the Figma credit form has no amount field, but the saved list shows amounts, so an amount field was added.
- **Daily average** = total expenses ÷ number of days since the first expense (minimum 1 day). **Weekly** = total expenses in the last 7 days. The design does not define these formulas.
- **Colours** were sampled from the Figma screens and live in `lib/utils/app_colors.dart`.
- **Profile photo** is copied into the app's documents folder, and only its file name is stored. This keeps it valid even if the app container path changes.
- The user's name and photo are stored with `shared_preferences` because they are single values and not records.

---

## Known issues and incomplete features

- **Web is not supported** (`sqflite` has no web implementation). Run on Android or iOS.
- **Camera** cannot be tested on the iOS Simulator (no camera). Gallery works.
- **Credits cannot be edited**, only added and deleted. The Figma design has no credit edit screen.
- **Due-date reminders or notifications** for credits are not implemented (not in the requirements).
- **Categories** are a fixed list and cannot be customised by the user.
- **Pixel-perfect matching** with Figma is approximate. Fonts, exact spacing and some icon shapes may differ slightly.
- **Clear Storage** does not reset the "onboarding seen" flag, so onboarding will not reappear until the app is reinstalled.
- **No automated tests** were written because of the time limit. Testing was done manually (see below).

---

## Manual test checklist

- [ ] Fresh install shows splash, then onboarding, then asks for a name, then Home
- [ ] Relaunch goes splash straight to Home (onboarding not shown again)
- [ ] Add an expense and an income, and the totals update on Home
- [ ] Edit a transaction by tapping it, and the list and totals update
- [ ] Swipe left, delete, and the confirmation dialog appears (Cancel keeps it, Delete removes it)
- [ ] Delete all transactions, and the empty state appears
- [ ] Validation: empty name, empty amount, `0`, and non-numeric input are all blocked with messages
- [ ] Close and reopen the app, and the data is still there
- [ ] Credit: add one with today's date (shows "Due Today"), then delete it
- [ ] Profile: change the name, change the photo, remove the photo, and Clear Storage
- [ ] Try a small-screen emulator and check there are no overflow errors

---

## Author

**[Your Name]**
Flutter Machine Test: Lilac Infotech
