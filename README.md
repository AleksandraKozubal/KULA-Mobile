## Kebabowe Uniwersum LegnicA

KULA-Mobile is a mobile application designed to help users locate and explore kebab points in Legnica city. Whether you're a local or a visitor, this app provides an easy way to find the best kebab spots around you.

## Project Setup

1. Requirements:

- **flutter SDK** - version 3.24.3 or newer
- **android SDK** - version 35.0.0 or newer
- **android SDK cmdline-tools** - version 11076708 or newer
- **android SDK Build-Tools** - verison 33.0.1 or newer
- **android emulator**
- **Visual Studio Code or preffered IDE** 
- Android Studio (optional)

2. Installation

- Reffering to docs: https://docs.flutter.dev/get-started/install
- Download android cmdline-tools and proceed with docs
- Download android SDK or use Android Studio installer to get both SDK and emulator

## Local development

Create .env from example .env (for Android local development use http://10.0.2.2:63251/api )
```
cp .env.example .env
```

Run command:
```
flutter run
```

## Application deployment

### Android .apk deployment

- Use command:
```
flutter build apk --split-per-abi
```
- Upload proper .apk to your device and install it.

### iOS deployment

(*Requires Apple Developer Account*)

- Follow official flutter documentation:
https://docs.flutter.dev/deployment/ios

## Useful commands: 
- To check if your project is setup properly use:
```shell
flutter doctor 
```
- In order to run project on android emulator use:
```shell
flutter run
```
- To get project's dependecies (packages) use:
```shell
flutter pub get
```
- To analyze project for futher testing errors use:
```shell
flutter analyze
```
- To lint whole project use:
```shell
dart format .
```
