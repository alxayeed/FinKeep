# Spendly - Encrypted Backup & Restore Implementation Plan

## Goal
Export the entire Hive database into a single encrypted file (`.spdb`) which can be shared using the system share sheet, and import it back via a file picker.

## Design Decisions
1. **Key Management**: Use an **App-wide Static Key (Obfuscated)** compiled in the binary for a frictionless experience.
2. **Encryption**: AES-256-CBC using the `encrypt` package.
3. **Sharing**: Use `share_plus` to trigger native share options.
4. **Importing**: Use `file_picker` to pick only `.spdb` files (filtered).

## Progress Checklist

- [x] 1. Add dependencies (`encrypt`, `share_plus`, `file_picker`, `path_provider`) to `pubspec.yaml`
- [x] 2. Update `BackupService` to handle encryption and decryption
- [x] 3. Update `BackupRestoreScreen` UI:
  - [x] Implement file sharing for Export
  - [x] Implement file picker for Import
  - [x] Keep the UI clean and premium
- [x] 4. Verify end-to-end functionality (unit/manual verification)

## Phase 2: Centralized Exception Handling

### Goal
Standardize and improve error tracking app-wide by introducing a centralized `ExceptionHandler` utility that logs errors with stack traces and caller context, and mapping exceptions.

### Tasks
- [x] 1. Create `ExceptionHandler` class at `lib/core/error/exception_handler.dart`
- [x] 2. Integrate `ExceptionHandler` in `BackupRestoreScreen`
- [x] 3. Refactor key Controllers to use `ExceptionHandler.handle`:
  - [x] `MonthlyExpenseController`
  - [x] `BudgetController`
  - [x] `ExpenseReportController`
- [x] 4. Refactor Repository layer (`LendingRepositoryImpl`) to log exceptions via `ExceptionHandler`

