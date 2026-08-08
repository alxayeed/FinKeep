# FinKeep — Feature Planning

---

## Milestone 1: Generic Savings Feature

Replace the existing `investments` feature with a generalized `savings` feature covering
all savings instrument types: Cash, Bank Savings, DPS, FDR, Sanchaypatra, Bond, and Investment.

### Decisions
| Decision | Choice |
|---|---|
| Savings types | Cash · Bank Savings · DPS · FDR · Sanchaypatra · Bond · Investment |
| DPS installments | Defined monthly schedule + local notification reminders |
| Bank/Cash withdrawals | Separate `WithdrawalEntry` list |
| FDR renewal | Close old record, create new |
| Summary screen | Top overview card + per-type breakdown + status pie chart |
| Data migration | `amountInvested` + `transactionDate` → first `DepositEntry` |
| Feature access | All modes (no longer personal-only) |
| Nav label | `'Savings'` |
| Rename | `investments` → `savings` everywhere (folders, classes, routes, DB collections) |

### Data Model

**Enums**
- `SavingsType` — `cash | bankSavings | dps | fdr | sanchaypatra | bond | investment`
- `SavingsStatus` — `active | closed | matured | withdrawn | renewed | returnsStarted | completed | loss`
  - `validFor(SavingsType)` returns only relevant statuses per type

**Entities**
- `Savings` — core entity replacing `Investment`
  - Fields: `id`, `savingsType`, `title`, `institutionName?`, `accountNumber?`, `branch?`, `subType?`
    (Sanchaypatra type), `startDate`, `maturityDate?`, `monthlyInstallment?` (DPS), `tenureMonths?` (DPS),
    `deposits: List<DepositEntry>`, `withdrawals: List<WithdrawalEntry>`, `returns: List<ReturnEntry>`,
    `interestRate`, `expectedReturn`, `status`, `notes`, `docLinks`
  - Computed: `totalDeposited`, `totalWithdrawn`, `totalReceived`, `balance`, `outstandingCapital`,
    `paidInstallments`, `remainingInstallments`, `nextDueDate`
- `DepositEntry` — `id`, `amount`, `date`, `transactionId?`, `medium`, `notes`
- `WithdrawalEntry` — `id`, `amount`, `date`, `transactionId?`, `medium`, `notes`
- `ReturnEntry` — unchanged from current `ReturnEntry`

**Deposit strategy**
- Multi-deposit types (Cash, Bank Savings, DPS): `deposits` list grows over time
- Single-deposit types (FDR, Sanchaypatra, Bond, Investment): `deposits` list has exactly 1 entry

**Withdrawal strategy**
- Only for Cash and Bank Savings
- `WithdrawalEntry` list tracks money taken out; `balance = totalDeposited - totalWithdrawn`

### Form UI — Adaptive Sections

One `AddSavingsScreen` with sections that show/hide per `savingsType`:

| Section | Cash | Bank | DPS | FDR | Sanchay | Bond | Inv |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Type selector | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Basic info (title, date) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Institution name | ❌ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Account / Cert / Bond No. | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Branch | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Sub-type (Sanchaypatra) | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| DPS schedule fields | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Maturity date | ❌ | ❌ | auto | ✅ | ✅ | ✅ | opt |
| Interest / profit rate | ❌ | opt | ✅ | ✅ | ✅ | ✅ | ✅ |
| Expected return | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Initial deposit fields | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Detail Screen — Adaptive Sections

| Section | Cash | Bank | DPS | FDR | Sanchay | Bond | Inv |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Summary card | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Financial overview (adaptive) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| DPS schedule card + progress | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Deposit history + Add button | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Withdrawal history + Add button | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Return entries + Add button | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| Transaction info | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |

### Summary Screen
- Top card: totals across all types (total deposited, total returns, balance)
- Per-type breakdown rows: icon + label + total deposited + record count
- Status distribution pie chart (same as current investment chart)

### Notifications (DPS)
- Package: `flutter_local_notifications` + `timezone`
- `NotificationService`: `scheduleDpsReminders(Savings)`, `cancelDpsReminders(String id)`
- Schedule on: create DPS, add deposit (reschedule remaining), update DPS
- Cancel on: status changed to matured / withdrawn
- Notification fires at 9:00 AM on each installment due date

### Migration
- **Hive**: At app startup, if `'investments'` box exists → transform each entry (add
  `savingsType: 'investment'`, build `deposits` list from `amountInvested` + `transactionDate`) →
  write to `'savings'` box → delete old box
- **Firestore**: One-time migration gated by preferences flag → copy from `investments`/`investments_dev`
  to `savings`/`savings_dev`, adding `savingsType: 'investment'` field and building `deposits` array
- **Date preservation**: All original `deposit.date`, `return.date`, `startDate` values preserved as-is

### Files to Create / Modify

**New feature folder:** `lib/features/savings/` with `domain/`, `data/`, `presentation/`

**Core changes:**
- `lib/core/services/notification_service.dart` [NEW]
- `lib/core/services/local_db_service.dart` — add `savingsBox`, Hive migration
- `lib/core/services/firestore_migration_service.dart` — add `migrateSavings()`
- `lib/core/constants/app_strings.dart` — add `savingsCollection`
- `lib/core/routes/app_router.dart` — rename all investment routes → savings
- `lib/core/common/home_scaffold.dart` — label + route update, remove personal-only guard
- `lib/dependency_injection.dart` — swap Investment → Savings registrations
- `pubspec.yaml` — add `flutter_local_notifications`, `timezone`

**Deleted:** `lib/features/investments/` (entire folder)

### Tasks
- [ ] Add `flutter_local_notifications` + `timezone` to pubspec.yaml
- [ ] Create `SavingsType` and `SavingsStatus` enums
- [ ] Create `Savings`, `DepositEntry`, `WithdrawalEntry` domain entities
- [ ] Create `SavingsRepository` interface + use cases (add, get, update, delete, addDeposit, addWithdrawal, addReturn)
- [ ] Create `SavingsModel`, `DepositEntryModel`, `WithdrawalEntryModel` data models
- [ ] Create `SavingsDataSource` (abstract), Firestore + Hive implementations
- [ ] Create `SavingsRepositoryImpl`
- [ ] Create `NotificationService` with DPS scheduling logic
- [ ] Update `LocalDbService` — add `savingsBox` + Hive migration
- [ ] Update `FirestoreMigrationService` — add `migrateSavings()`
- [ ] Update `app_strings.dart` — add `savingsCollection`
- [ ] Create `SavingsController` (GetX)
- [ ] Create adaptive `AddSavingsScreen` + `EditSavingsScreen`
- [ ] Create adaptive `SavingsDetailScreen`
- [ ] Create `SavingsListScreen` + `SavingsSummaryScreen`
- [ ] Create bottom sheets: `AddDepositBottomSheet`, `AddWithdrawalBottomSheet`, `AddReturnBottomSheet`
- [ ] Create adaptive `SavingsItem` list card widget
- [ ] Update `app_router.dart` — rename routes
- [ ] Update `home_scaffold.dart` — nav label + route + remove personal guard
- [ ] Update `dependency_injection.dart`
- [ ] Delete `lib/features/investments/`
- [ ] Manual verification across all 7 savings types

---

## Milestone 2: Google Drive Sync — Backup & Restore

### User Journeys

- [ ] **First-time backup**: User connects Google account, picks frequency + time, taps "Back Up Now" — snapshot + empty deletion log uploaded to Drive.
- [ ] **Auto-backup fires**: App goes to background at the scheduled window → silent backup, no UI interruption. `lastBackupAt` updates. A badge shows "Last backed up: today at 2:00 AM".
- [ ] **Restore on new device**: Fresh install → "Restore from Google Drive" → sign in → latest snapshot downloaded → deletion log applied → local DB reflects exact state of last backup.
- [ ] **Delete a record, then restore**: User deletes expense #42 → deletion log updated on Drive immediately → even if restoring from an old snapshot that still contains #42, the deletion log removes it after import.
- [ ] **Two devices, one user**: Device A backs up. Device B restores. Device B deletes record #17. Deletion log updated. Device A restores → #17 is gone. Deletions propagate in both directions.
- [ ] **Already signed in**: Silent sign-in attempted first; no prompt shown unless token is expired.
- [ ] **No backup found on Drive**: Friendly dialog — "No backup found for this Google account."
- [ ] **Network failure mid-upload**: Staging file discarded. Drive's committed backup is untouched. Snackbar shown.
- [ ] **Revoked Google permissions**: 401 from Drive API → re-prompt sign-in flow.
- [ ] **Corrupt Drive file**: Decryption fails → error shown → pre-restore checkpoint auto-restores local DB.
- [ ] **Large backup on mobile data**: Dialog before upload — "You're on mobile data. Continue?"
- [ ] **Disconnect Google Drive**: Clears session, clears SharedPreferences keys, stops auto-backup scheduler.
- [ ] **Progress reporting**: Inline progress bar with bytes transferred + cancel button.

### Corner Cases

| # | Scenario | Handling |
|---|---|---|
| 1 | iOS sign-in sheet dismissed | `DriveSignInCancelledException` → snackbar |
| 2 | No Google account on device | `PlatformException` → prompt to add account |
| 3 | Drive scope denied | "Drive permission is required" |
| 4 | Auto-backup token refresh fails | Badge on next open: "Auto backup failed" |
| 5 | Double tap "Back Up Now" | Button disabled while in progress |
| 6 | App killed mid-upload | Staging file remains; next backup overwrites; committed backup untouched |
| 7 | Restore on non-empty DB | Confirmation dialog + pre-restore checkpoint |
| 8 | Drive file deleted by user | `getLastBackupMetadata()` returns null → "No backup found" |
| 9 | Large backup on slow connection | Progress bar + cancel button |
| 10 | Two devices back up simultaneously | `modifiedTime` conflict check → warn before overwrite |
| 11 | Wrong device clock | `lastBackupAt` from local SharedPreferences |
| 12 | OAuth token revoked | 401 → force re-sign-in |
| 13 | Drive storage full | appDataFolder doesn't count against user quota |
| 14 | Rate limited (429) | "Too many requests. Please try again." |
| 15 | Corrupt remote backup | Decrypt fails → checkpoint auto-restores |
| 16 | No internet | "No internet connection." |
| 17 | Airplane mode mid-download | Partial bytes discarded; checkpoint auto-restores |
| 18 | iOS background execution limit | Timeout gracefully; `lastBackupAt` not updated |
| 19 | User changes Google account | Disconnect + reconnect flow |
| 20 | Delete record while offline | ID queued in local deletion log; uploaded on reconnect |
| 21 | Restore from old backup | Deletion log applied after import |
| 22 | Deletion log corrupted | Local log is authoritative; re-uploaded on next backup |

### Tasks
- [ ] `pubspec.yaml` — add `google_sign_in`, `googleapis`, `http`
- [ ] `android/app/AndroidManifest.xml` — add `<queries>` block + INTERNET permission
- [ ] `ios/Runner/Info.plist` — add `GIDClientID` reverse URL scheme
- [ ] `drive_exceptions.dart` [NEW] — typed exception classes
- [ ] `google_drive_service.dart` [NEW] — sign-in, upload, download, metadata, deletion log sync
- [ ] `deletion_log_service.dart` [NEW] — record, merge, apply, purge, offline queue
- [ ] `google_drive_sync_controller.dart` [NEW] — GetX controller with full reactive state
- [ ] `backup_restore_screen.dart` — add Google Drive Sync section
- [ ] `backup_service.dart` — add `createCheckpoint()` + `restoreFromCheckpoint()`
- [ ] `main.dart` — add `WidgetsBindingObserver` for background backup + offline flush
- [ ] `dependency_injection.dart` — register Drive service + controller
- [ ] All delete actions — call `DeletionLogService.recordDeletion(id)` after each hard delete

---

## Backlog (Future Milestones)

### Financial Accounts / Sources System
Track WHERE money lives. Every transaction has a source + destination account.
Transfers between own accounts are tagged as "Transfer" and excluded from income/expense totals.

- Account types: Bank account, Mobile wallet (bKash/Nagad/Rocket), Cash
- Model: opening balance set by user; running balance computed from all linked transactions
- Transfers: source + destination, excluded from P&L
- Impact: income, expense, savings, lending all get a `sourceAccountId` field
- Net worth view: shows balance per account + savings instruments

### Income ↔ Savings Integration
- Savings returns (FDR interest, Sanchaypatra profit) credited to a financial account
- Account balance reflects in net worth, not as duplicate income records
- "Savings gap" insight: income − expense = suggested savings amount for the month

### Tax Return Support
- Dedicated Tax Report screen under fiscal year filter
- Tax-rebate eligible instruments: Sanchaypatra, DPS (auto-flagged by type)
- Non-eligible but taxable returns: FDR interest, bond coupons, investment gains
- Output: total income, savings for rebate, investment income, estimated tax payable
