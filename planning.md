# Currency Preferences Refactoring & Fix Plan

Move currency enum to core/enums, create a premium reusable single-select currency widget, and implement InheritedNotifier to resolve immediate refresh issues.

---

## User Journeys (Non-Technical)

- [x] **Instant Currency Selection & Rebuild**: Selecting a new currency instantly updates the symbols/icons on all screens, including background screens in GoRouter's stack, without requiring screen-navigation.
- [x] **Reusable Selector Widget**: The settings screen uses a premium, styled currency selector widget.
- [x] **Generic Single-Select Widget**: Converted the currency selector to a generic `StyledSingleSelector<T>` to support selecting other options like language.
- [x] **Language Selector Integration**: Wired the settings screen language selection tile to reactively use the generic `StyledSingleSelector<String>` with `AppLocalizations`.

---

## Code Changes (Technical)

- [x] **[currency.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/enums/currency.dart)**: Move Currency enum to core/enums.
- [x] **[currency_provider.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/styles/currency_provider.dart)**: Update to use the moved enum, define `CurrencyTheme` (InheritedNotifier), and add `BuildContext` extension.
- [x] **[main.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/main.dart)**: Wrap root `MaterialApp.router` with `CurrencyTheme` and `AppLocalizations.localeListenable` builder.
- [x] **[styled_currency_selector.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/widgets/styled_currency_selector.dart)**: Redefined class as generic `StyledSingleSelector<T>`.
- [x] **[widgets.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/widgets/widgets.dart)**: Export the generic selector.
- [x] **[settings_screen.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/settings_screen.dart)**: Implement `_showLanguageSelector` and use `StyledSingleSelector` for both currency and language selections.
- [x] **Dynamic Context-based Rebuilding**: Update dynamic symbol and icon references to use `context.currency.symbol` and `context.currency.icon` instead of direct static calls.

---

## Verification

- [x] **Verification**: Run `flutter analyze` and confirm instant reactive updates.

---

# Local Notifications Fix Plan

Fix local notification configuration issues on Android and implement the missing notifications implementation on iOS.

## User Journeys (Non-Technical)

- [x] **Daily Reminder Setup**: Users can toggle daily notifications in the settings screen and schedule them for a specific time.
- [x] **Test Notification**: Users can trigger an immediate test notification from the settings screen on both Android and iOS devices, which successfully displays.
- [x] **Resilience**: Scheduled notifications persist and fire accurately according to the selected time.

## Code Changes (Technical)

- [x] **[AndroidManifest.xml](file:///Volumes/DEV/Projects/FinKeep/FinKeep/android/app/src/main/AndroidManifest.xml)**: Register ScheduledNotificationReceiver and ScheduledNotificationBootReceiver. Include RECEIVE_BOOT_COMPLETED permission.
- [x] **[AppDelegate.swift](file:///Volumes/DEV/Projects/FinKeep/FinKeep/ios/Runner/AppDelegate.swift)**: Configure UNUserNotificationCenter delegate to handle notifications in the foreground and tap callbacks.
- [x] **[expense_reminder_ios.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/features/expense/services/expense_reminder_ios.dart)**: Implement `IosExpenseReminderService` with local notifications initialization, scheduling, cancellation, and immediate show methods.
- [x] **[expense_reminder_android.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/features/expense/services/expense_reminder_android.dart)**: Ensure `showTestNotificationNow` requests notification permission before firing.

## Verification

- [x] **Verification**: Run static analysis and verify build functionality.

