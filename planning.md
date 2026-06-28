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

---

# Google Drive Sync — Backup & Restore Plan

Add a "Sync to Google Drive" option to the Backup & Restore screen, mirroring the WhatsApp backup experience. Any user can back up encrypted data to their own private Google Drive `appDataFolder` (hidden from Drive UI, doesn't use quota) and restore on any device — with zero risk of data loss, including intentional deletions.

---

## Key Design Decisions

### 1. Backup Frequency & Time (WhatsApp-style)
The user chooses:
- **Frequency**: Daily / Weekly / Monthly (same pattern as the existing reminder service)
- **Time**: Time-picker (e.g., 2:00 AM) — same UX as the reminder time picker
- Backup is triggered via `AppLifecycleState.paused` (app goes to background) when the scheduled window is due, or manually via "Back Up Now".

### 2. Drive File Structure — Atomic Two-Phase Upload
Three files in `appDataFolder` (all hidden from the user, managed internally):

```
finkeep_backup.spdb          ← committed snapshot (latest good backup)
finkeep_backup_prev.spdb     ← previous snapshot (silent safety net)
finkeep_backup_staging.spdb  ← in-progress upload only (deleted after commit)
finkeep_deletions.json       ← deletion log {recordId: deletedAt, ...}
```

**Upload is atomic — old backup is NEVER touched until new one is verified:**
1. Upload new bytes → `_staging` (old `_backup` untouched)
2. Verify upload checksum matches local bytes
3. Delete `_prev`; rename `_backup` → `_prev`; rename `_staging` → `_backup`
4. If step 1–2 fails: abort, `_staging` discarded, old backup 100% intact

### 3. Deletion Log — Solving Ghost Data Resurrection
**The problem**: Any backup is a point-in-time snapshot. If a user deletes a record after the last backup and then restores, the deleted record comes back.

**The solution**: A separate lightweight `finkeep_deletions.json` file on Drive tracks every intentionally deleted record ID.

**Workflow**:
- User deletes a record → ID + timestamp written to local deletion log → uploaded to Drive immediately (even before next backup)
- On restore: full snapshot is imported first, then deletion log is applied (any record in the log is removed from local DB)
- Two-device scenario: both devices share the same deletion log on Drive; deletions from either device propagate to the other on next restore
- Log housekeeping: entries older than 90 days are purged (any backup older than 90 days is considered stale)
- Offline deletions: queued locally and uploaded to Drive on next connection — no deletion is ever lost

**Deletion log is separate from the snapshot** — no model schema changes, no Hive migrations.

### 4. Pre-Restore Local Checkpoint
Before any restore overwrites local data:
1. Export current local DB → `restore_checkpoint.spdb` in app documents
2. Begin import from Drive snapshot + apply deletion log
3. If import succeeds → delete checkpoint
4. If import throws at any point → auto-recover from checkpoint (pre-restore state fully restored)

### 5. Multi-Device Conflict Detection
- `lastBackupAt` is persisted locally in `SharedPreferences`
- Before upload: read Drive file's `modifiedTime`. If Drive is newer than local `lastBackupAt` → warn: *"Another device backed up more recently. Uploading will overwrite that backup. Continue?"*

---

## User Journeys (Non-Technical)

- [ ] **First-time backup**: User connects Google account, picks frequency + time, taps "Back Up Now" — snapshot + empty deletion log uploaded to Drive.
- [ ] **Auto-backup fires**: App goes to background at the scheduled window → silent backup, no UI interruption. `lastBackupAt` updates. A badge shows "Last backed up: today at 2:00 AM".
- [ ] **Restore on new device**: Fresh install → "Restore from Google Drive" → sign in → latest snapshot downloaded → deletion log applied → local DB reflects exact state of last backup including all deletions.
- [ ] **Delete a record, then restore**: User deletes expense #42 → deletion log updated on Drive immediately → even if they restore from an old snapshot that still contains #42, the deletion log removes it after import. #42 never comes back.
- [ ] **Two devices, one user**: Device A backs up. Device B restores. Device B deletes record #17. Deletion log on Drive updated. Device A restores → #17 is gone. Deletions propagate in both directions.
- [ ] **Already signed in**: Silent sign-in attempted first; no prompt shown unless token is expired.
- [ ] **No backup found on Drive**: Friendly dialog — "No backup found for this Google account."
- [ ] **Network failure mid-upload**: Staging file discarded. Drive's committed backup is untouched. Snackbar shown. Next scheduled backup retries.
- [ ] **Revoked Google permissions**: 401 from Drive API → re-prompt sign-in flow.
- [ ] **Corrupt Drive file**: Decryption fails → error shown → pre-restore checkpoint auto-restores local DB. Zero data loss.
- [ ] **Large backup on mobile data**: Dialog before upload — "You're on mobile data. Continue?"
- [ ] **Disconnect Google Drive**: Clears session, clears `SharedPreferences` keys, stops auto-backup scheduler.
- [ ] **Progress reporting**: Inline progress bar with bytes transferred + cancel button.

---

## Corner Cases — Full Coverage

| # | Scenario | Handling |
|---|----------|---------|
| 1 | iOS sign-in sheet dismissed | `DriveSignInCancelledException` → "Sign in was cancelled." snackbar |
| 2 | No Google account on Android device | `PlatformException` → "Please add a Google account in device settings." |
| 3 | Drive scope denied | Null/empty scopes → "Drive permission is required for this feature." |
| 4 | Auto-backup token refresh fails silently | Error logged; badge shown on next app open: "Auto backup failed — tap to retry" |
| 5 | User taps "Back Up Now" twice | Button disabled while `status != idle`; no double-upload |
| 6 | App killed mid-upload | `_staging` file remains; next backup overwrites it; committed backup untouched |
| 7 | Restore on non-empty DB | Confirmation dialog; pre-restore checkpoint created before any change |
| 8 | Drive file deleted manually by user | `getLastBackupMetadata()` returns null → "No backup found" UI |
| 9 | Large backup on slow connection | Progress bar with bytes; cancel button aborts upload; staging discarded |
| 10 | Two devices back up simultaneously | Multi-device conflict check (Drive `modifiedTime` vs local `lastBackupAt`) → warn before overwrite |
| 11 | Device clock is wrong | `lastBackupAt` displayed from local `SharedPreferences`, not derived from Drive metadata |
| 12 | OAuth token revoked from Google settings | 401 → force re-sign-in flow |
| 13 | Drive storage full (non-appDataFolder quota) | appDataFolder doesn't count against user quota — this scenario doesn't apply; document this to user |
| 14 | Rate limited (429) | `DriveRateLimitException` → "Too many requests. Please try again in a few minutes." |
| 15 | Corrupt remote backup file | Decrypt fails → checkpoint auto-restores; "Backup file is damaged." shown |
| 16 | No internet | `DriveNoNetworkException` → "No internet connection." |
| 17 | Airplane mode toggled mid-download | Exception caught; partial bytes discarded; checkpoint auto-restores local DB |
| 18 | iOS background execution limit (~30s) | Timeout set; abort gracefully; `lastBackupAt` not updated; retry on next cycle |
| 19 | User changes Google account | Disconnect + reconnect flow; old email pref replaced |
| 20 | Delete record while offline | ID queued in local deletion log; uploaded to Drive on next connection |
| 21 | Restore from 3-month-old backup | Deletion log applied after import; all deletions in the last 3 months propagate |
| 22 | Deletion log itself corrupted on Drive | Local deletion log is authoritative; re-uploaded on next backup |

---

## Code Changes (Technical)

- [ ] **[pubspec.yaml](file:///Volumes/DEV/Projects/FinKeep/FinKeep/pubspec.yaml)**: Add `google_sign_in: ^6.2.2`, `googleapis: ^14.0.0`, `http: ^1.2.2`.
- [ ] **`android/app/src/main/AndroidManifest.xml`**: Add `<queries>` block for Google sign-in intent resolution (Android 11+) and INTERNET permission if missing.
- [ ] **`ios/Runner/Info.plist`**: Add `GIDClientID` reverse URL scheme (from `GoogleService-Info.plist`) for OAuth redirect callback.
- [ ] **[drive_exceptions.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/drive_exceptions.dart)** [NEW]: Typed exception classes — `DriveNoNetworkException`, `DriveSignInCancelledException`, `DriveSignInFailedException`, `DriveAuthRevokedException`, `DriveUploadFailedException`, `DriveQuotaExceededException`, `DriveRateLimitException`.
- [ ] **[google_drive_service.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/google_drive_service.dart)** [NEW]: `signIn()`, `signOut()`, `getSignedInAccount()`, `uploadBackup(bytes, fileName)` (atomic two-phase), `downloadLatestBackup(fileName)`, `getLastBackupMetadata()`, `uploadDeletionLog(Map)`, `downloadDeletionLog()`. All Drive errors mapped to typed exceptions.
- [ ] **[deletion_log_service.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/deletion_log_service.dart)** [NEW]: `recordDeletion(String id)`, `getDeletionLog()`, `mergeWithRemote(Map remote)`, `applyToBoxes(LocalDbService)`, `purgeOldEntries()`, `queueOfflineDeletion(String id)`, `flushOfflineQueue()`. Persists locally via SharedPreferences or a small Hive box; syncs to Drive on each backup and immediately on delete when online.
- [ ] **[google_drive_sync_controller.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/controllers/google_drive_sync_controller.dart)** [NEW]: GetX controller. Reactive state: `status` (enum), `progressText`, `progressBytes`, `totalBytes`, `connectedEmail`, `lastBackupAt`, `autoBackupEnabled`, `backupFrequency` (daily/weekly/monthly), `backupTime` (TimeOfDay), `errorMessage`. Actions: `signIn()`, `signOut()`, `backupNow()`, `restoreFromDrive()`, `checkLastBackupInfo()`, `toggleAutoBackup()`, `setFrequency()`, `setBackupTime()`. SharedPreferences keys: `gdrive_email`, `gdrive_last_backup_at`, `gdrive_auto_backup_enabled`, `gdrive_frequency`, `gdrive_backup_hour`, `gdrive_backup_minute`.
- [ ] **[backup_restore_screen.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/backup_restore_screen.dart)**: Add "GOOGLE DRIVE SYNC" section. When not signed in: connect card. When signed in: connected email + disconnect, last backup label, frequency selector (Daily/Weekly/Monthly), time picker, auto-backup toggle, "Back Up Now" + "Restore from Drive" buttons, inline progress bar with cancel.
- [ ] **[backup_service.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/backup_service.dart)**: Add `createCheckpoint(directory)` and `restoreFromCheckpoint(path)` methods for pre-restore safety.
- [ ] **[main.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/main.dart)**: Add `WidgetsBindingObserver`; on `AppLifecycleState.paused`, check if auto-backup is due (frequency + time window) and trigger silent backup. On `AppLifecycleState.resumed`, flush any offline deletion queue.
- [ ] **[dependency_injection.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/dependency_injection.dart)**: Register `GoogleDriveService`, `DeletionLogService`, and `GoogleDriveSyncController` as lazy singletons.
- [ ] **All delete actions** (ExpenseRepository, InvestmentRepository, LendingRepository, etc.): After each hard delete, call `DeletionLogService.recordDeletion(id)`.

---

## Verification

- [ ] **Unit Tests**: Mock `GoogleSignIn`, `DriveApi`, `BackupService`, `DeletionLogService` via mocktail. Cover all 22 corner cases.
- [ ] **Manual Android**: Full sign-in → backup → delete record → restore → confirm deleted record does not reappear.
- [ ] **Manual iOS**: Sign-in sheet, backup, restore cycle on iOS Simulator.
- [ ] **Two-device test**: Back up on Device A → restore on Device B → delete on B → restore on A → confirm deletion propagated.
- [ ] **Airplane mode test**: Delete record offline → go online → confirm deletion log uploaded to Drive.
- [ ] **Corrupt file test**: Manually corrupt Drive backup → restore → confirm local DB unchanged (checkpoint restored).
- [ ] **Mid-upload kill test**: Force-kill app during upload → relaunch → confirm Drive committed backup is intact.
- [ ] **`flutter analyze`**: No new warnings or errors.

---

# FCM Push Notifications Plan

Implement FCM Push Notifications to support foreground, background, and terminated app state messaging for testing.

## User Journeys (Non-Technical)
- [x] **Notification permission**: User is prompted to allow notifications on startup or when testing notifications.
- [x] **FCM token display**: Logged in the console (no UI card as per user preference).
- [x] **Foreground notifications**: User receives and sees notifications locally when the app is open.
- [x] **Background / Terminated notifications**: User receives notifications when the app is in the background or closed.

## Code Changes (Technical)
- [x] **[pubspec.yaml](file:///Volumes/DEV/Projects/FinKeep/FinKeep/pubspec.yaml)**: Add `firebase_messaging` dependency.
- [x] **[push_notification_service.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/push_notification_service.dart)** [NEW]: Implement FCM messaging init, background handlers, local notification presentation, and token access.
- [x] **[dependency_injection.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/dependency_injection.dart)**: Register `PushNotificationService` as a singleton.
- [x] **[main.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/main.dart)**: Initialize `PushNotificationService`.
- [x] **[settings_screen.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/settings_screen.dart)**: Skipped UI card as per user request (logs token to console instead).

## Verification
- [x] **Verification**: Run `flutter analyze` and verify FCM push notifications trigger on devices in foreground, background, and terminated states.


