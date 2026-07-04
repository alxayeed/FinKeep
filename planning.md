# Planning: Income & Cash-In Feature Implementation

## Phase 1: Storage & Data Foundations (Data Layer)
- [ ] **Task 1.1: IncomeCategory & Income Models**
  - Implement `IncomeCategoryModel` (`id`, `displayLabel`, `emoji`, `isCustom`, `isDeleted`).
  - Implement `IncomeModel` (`id`, `amount`, `description`, `date`, `categoryId`, `createdAt`).
  - Build defensive JSON serialization (`fromJson`/`toJson`) with fallback values for safety.
- [ ] **Task 1.2: Data Sources & Repositories**
  - Create `IncomeLocalDataSource` (Hive implementation with seeding logic for 6 core categories: Salary, Freelance, Business, Allowance, Investment, Other).
  - Create `IncomeRemoteDataSource` (Firestore integration).
  - Implement `IncomeRepositoryImpl` handling local/remote toggling based on `AppConfig.useRemote`.
- [ ] **Task 1.3: Hive Registration**
  - Configure `income$suffix` and `income_categories$suffix` in `LocalDbService` and update dependency injection.

## Phase 2: Domain Layer & Use Cases
- [ ] **Task 2.1: Domain Entities & Repository Interfaces**
  - Create `IncomeEntity` and `IncomeCategoryEntity`.
  - Define `IncomeRepository` interface.
- [ ] **Task 2.2: Implement Use Cases**
  - Add use cases: Add/Get/Update/Delete for both income and income categories.

## Phase 3: State Management (GetX Controllers)
- [ ] **Task 3.1: IncomeCategoryController**
  - Implement reactive category fetch, create, and soft-delete methods.
  - Add custom category limit checks (`maxCustomCategoryLimit`, `canAddCustomCategory`).
- [ ] **Task 3.2: IncomeController**
  - CRUD operations for logging, updating, and deleting income data.
  - Build a responsive month/range filter stream to fetch active records.
- [ ] **Task 3.3: Merged Category Filtering**
  - Write reactive evaluation loop combining active categories with historical soft-deleted categories that contain records.

## Phase 4: User Interface Development (Presentation Layer)
- [ ] **Task 4.1: Create Income Screen**
  - Build `CreateIncomeScreen` matching `CreateExpenseScreen` styling.
- [ ] **Task 4.2: Edit & Detail Screens**
  - Build `EditIncomeScreen` and `IncomeDetailsScreen` matching expense counterparts.
- [ ] **Task 4.3: Income List & Summary Tab Screens**
  - Build `IncomeScreen` as the parent view with sub-tabs for Summary (pie charts, statistics) and List (chronological grouped logs).
- [ ] **Task 4.4: Category Configuration Settings View**
  - Implement settings screen for managing custom categories and editing/deleting them.
- [ ] **Task 4.5: App Router & Navigation**
  - Wire routes in `AppRouter` and add the Income tab to `HomeScaffold`.

---

# Google Drive Sync — Backup & Restore Plan

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

## Code Changes (Technical)

- [ ] **`pubspec.yaml`**: Add `google_sign_in: ^6.2.2`, `googleapis: ^14.0.0`, `http: ^1.2.2`.
- [ ] **`android/app/src/main/AndroidManifest.xml`**: Add `<queries>` block for Google sign-in intent resolution (Android 11+) and INTERNET permission if missing.
- [ ] **`ios/Runner/Info.plist`**: Add `GIDClientID` reverse URL scheme (from `GoogleService-Info.plist`) for OAuth redirect callback.
- [ ] **`drive_exceptions.dart`** [NEW]: Typed exception classes — `DriveNoNetworkException`, `DriveSignInCancelledException`, `DriveSignInFailedException`, `DriveAuthRevokedException`, `DriveUploadFailedException`, `DriveQuotaExceededException`, `DriveRateLimitException`.
- [ ] **`google_drive_service.dart`** [NEW]: `signIn()`, `signOut()`, `getSignedInAccount()`, `uploadBackup(bytes, fileName)` (atomic two-phase), `downloadLatestBackup(fileName)`, `getLastBackupMetadata()`, `uploadDeletionLog(Map)`, `downloadDeletionLog()`. All Drive errors mapped to typed exceptions.
- [ ] **`deletion_log_service.dart`** [NEW]: `recordDeletion(String id)`, `getDeletionLog()`, `mergeWithRemote(Map remote)`, `applyToBoxes(LocalDbService)`, `purgeOldEntries()`, `queueOfflineDeletion(String id)`, `flushOfflineQueue()`. Persists locally via SharedPreferences or a small Hive box; syncs to Drive on each backup and immediately on delete when online.
- [ ] **`google_drive_sync_controller.dart`** [NEW]: GetX controller. Reactive state: `status` (enum), `progressText`, `progressBytes`, `totalBytes`, `connectedEmail`, `lastBackupAt`, `autoBackupEnabled`, `backupFrequency` (daily/weekly/monthly), `backupTime` (TimeOfDay), `errorMessage`. Actions: `signIn()`, `signOut()`, `backupNow()`, `restoreFromDrive()`, `checkLastBackupInfo()`, `toggleAutoBackup()`, `setFrequency()`, `setBackupTime()`. SharedPreferences keys: `gdrive_email`, `gdrive_last_backup_at`, `gdrive_auto_backup_enabled`, `gdrive_frequency`, `gdrive_backup_hour`, `gdrive_backup_minute`.
- [ ] **`backup_restore_screen.dart`**: Add "GOOGLE DRIVE SYNC" section. When not signed in: connect card. When signed in: connected email + disconnect, last backup label, frequency selector (Daily/Weekly/Monthly), time picker, auto-backup toggle, "Back Up Now" + "Restore from Drive" buttons, inline progress bar with cancel.
- [ ] **`backup_service.dart`**: Add `createCheckpoint(directory)` and `restoreFromCheckpoint(path)` methods for pre-restore safety.
- [ ] **`main.dart`**: Add `WidgetsBindingObserver`; on `AppLifecycleState.paused`, check if auto-backup is due (frequency + time window) and trigger silent backup. On `AppLifecycleState.resumed`, flush any offline deletion queue.
- [ ] **`dependency_injection.dart`**: Register `GoogleDriveService`, `DeletionLogService`, and `GoogleDriveSyncController` as lazy singletons.
- [ ] **All delete actions** (ExpenseRepository, InvestmentRepository, LendingRepository, etc.): After each hard delete, call `DeletionLogService.recordDeletion(id)`.

## Verification

- [ ] **Unit Tests**: Mock `GoogleSignIn`, `DriveApi`, `BackupService`, `DeletionLogService` via mocktail. Cover all 22 corner cases.
- [ ] **Manual Android**: Full sign-in → backup → delete record → restore → confirm deleted record does not reappear.
- [ ] **Manual iOS**: Sign-in sheet, backup, restore cycle on iOS Simulator.
- [ ] **Two-device test**: Back up on Device A → restore on Device B → delete on B → restore on A → confirm deletion propagated.
- [ ] **Airplane mode test**: Delete record offline → go online → confirm deletion log uploaded to Drive.
- [ ] **Corrupt file test**: Manually corrupt Drive backup → restore → confirm local DB unchanged (checkpoint restored).
- [ ] **Mid-upload kill test**: Force-kill app during upload → relaunch → confirm Drive committed backup is intact.
- [ ] **`flutter analyze`**: No new warnings or errors.
