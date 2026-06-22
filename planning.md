# Local Privacy Policy PDF Plan

A streamlined plan to display the privacy policy locally from assets.

---

## User Journeys (Non-Technical)

- [x] **Open Privacy Policy**: User clicks on "Privacy Policy" in settings and sees the local PDF file rendered.
- [x] **Offline Access**: User can open the privacy policy without an internet connection.

---

## Code Changes (Technical)

- [x] **[pubspec.yaml](file:///Volumes/DEV/Projects/FinKeep/FinKeep/pubspec.yaml)**: Register local asset files directory and add `syncfusion_flutter_pdfviewer` dependency.
- [x] **[privacy_policy_screen.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/privacy_policy_screen.dart)**: Render PDF using `SfPdfViewer.asset`.
- [x] **[app_router.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/routes/app_router.dart)**: Update route definition for privacy policy to load local screen directly without web URL parameter.

---

## Verification

- [x] **Manual Verification**: Run `flutter analyze` and confirm there are no errors in our modifications.
