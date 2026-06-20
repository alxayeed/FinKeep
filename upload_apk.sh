#!/bin/bash

#example file name - upload_apk.sh

flutter build apk --release --split-per-abi --dart-define=ENV=personal #personal, dev, local



APK_PATH="build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
APP_ID="1:638261628234:android:94864f17200d725b0e85b3"
RELEASE_NOTES_FILE_PATH="changelog.txt"
TESTERS_EMAILS="alxayeed@gmail.com"  # Add tester emails, separated by commas
TESTERS_GROUP="me"  # Use a group name, or use --users for individual emails

# Step 3: Upload the APK to Firebase App Distribution with additional details
firebase appdistribution:distribute $APK_PATH --app $APP_ID \
    --release-notes-file $RELEASE_NOTES_FILE_PATH \
    --groups "$TESTERS_GROUP" \


#firebase appdistribution:distribute $APK_PATH --app $APP_ID \
#    --release-notes "Test release note" \
#    --testers "$TESTERS_EMAILS"