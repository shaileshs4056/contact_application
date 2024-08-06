# A Demo Structure Flutter project.

## Environment

**Flutter version** : 3.16.x

**Flutter channel** : Stable

## Device OS support

**iOS**
- iOS 13+

**Android**
- Android 6.0+
    - minSdkVersion 21
- targetSdkVersion 33

## Code Style
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## Code Analysis
- [SonarQube](https://www.sonarsource.com/products/sonarqube/) 

## Assets Generator
- Use [FlutterAssetsGenerator](https://plugins.jetbrains.com/plugin/15427-flutterassetsgenerator) **(lib/generated/assets.dart)**

## Models

**To generate models use below site/plugin**

- [QuickType](https://app.quicktype.io/)
- [AdvancedJson2Dart](https://plugins.jetbrains.com/plugin/16236-advancedjson2dart)

## Architecture

|Working status|Category|Description|

|:---:|---|---|

| ✅ | Base | Using [Mobx](https://pub.dev/packages/mobx) + [build_runner](https://pub.dev/packages/build_runner)  

| ✅ | Networking | Using [dio](https://pub.dev/packages/dio) 

| ✅ | Data | Using [json serializable](https://pub.dev/packages/json_serializable) 

| ✅ | Session Management | Using [Hive](https://pub.dev/packages/hive)


## Localization
Using this library to handle multi-languages. Follow this guide to understand and config languages files

### Setup Step:

* VSC, AS, IJ users need to install the plugins from the market.
* vs-code: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl
* intelliJ / android studio: https://plugins.jetbrains.com/plugin/13666-flutter-intl

* others/CLI:
```
flutter pub global activate intl_utils

flutter pub global run intl_utils:generate
```

### Initialize plugins (IntelliJ reference)
1. Open Flutter intl in `Action`
2. Click on `arb File`
3. To add / remove Locale, choose `Add Locale` / `Remove Locale`
4. Then it will prompt which locale

**Current available locale is en**

Link library : https://pub.dev/packages/intl_utils
