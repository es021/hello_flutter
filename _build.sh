# https://flutter.dev/docs/deployment/android#signing-the-app
flutter clean


# app bundle ni dah boleh upload to google store
flutter build appbundle

# kalau nak generate apk jugak : 
# <app dir>/build/app/outputs/apk/release/app-arm64-v8a-release.apk
flutter build apk --split-per-abi