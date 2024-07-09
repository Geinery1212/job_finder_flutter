# Job Finder Application

This is a Flutter application, a job finder application.

## Build Information

The application is built using:
- **Flutter 3.10.5** • channel stable • https://github.com/flutter/flutter.git
- **Tools** • Dart 3.0.5 • DevTools 2.23.1
- **Java 11**

## Easy Setup

1. Create a project in [Firebase Console](https://console.firebase.google.com/u/2/?pli=1).
2. Register your app as an Android Application in Firebase. Most of the data required to register your Android app can be found in the `build.gradle` file.
3. Once you complete the registration process, download the `google-services.json` file and follow the instructions provided on the Firebase page.
4. In your Firebase console, enable authentication with Email/Password.
5. Create a database in the Cloud Firestore/Firestore Database and rewrite the rules for test purposes:
    ```plaintext
    match /{document=**} {
      allow read, write: if true;
    }
    ```
6. Enable Storage and rewrite the rules for test purposes:
    ```plaintext
    match /{allPaths=**} {
      allow read, write: if true;
    }
    ```
7. If you added the `google-services.json` correctly, you should be able to run the application without any problems.

## Considerations

- The app might not work correctly the first time because you will need to create indexes for the Cloud Firestore. To make it easy, check your console for URLs that will be displayed. Copy and paste them one by one into your browser. You will be redirected to your Firebase console, where you only need to confirm to create the indexes.
- You will need to create at least 3 Collection IDs with their fields indexed.

**Note**: I am going to add my `google-services.json` but I do not know until when it will be available. :)