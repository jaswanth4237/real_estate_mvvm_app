# EstateView

Real estate listing sample app built with Flutter using MVVM + Clean Architecture concepts, offline-friendly caching, feature flags, and mixed state management (`flutter_bloc` + `provider`).

## Contents

1. Overview
2. Features
3. Tech Stack
4. Project Structure
5. Getting Started
6. Running the App
7. Testing and Coverage
8. Data and Storage
9. Configuration
10. Troubleshooting

## Overview

EstateView displays a paginated list of properties, supports detail navigation, manages favorites and search history locally, and tracks selected app events (feature usage, performance metrics, and error logs).

The app uses:

- Remote API data from `jsonplaceholder.typicode.com/posts`.
- Local persistence via Hive and JSON files in an app-specific data directory.
- Dependency injection through `get_it`.
- `Bloc` for list states/events and `Provider` for theme/details view models.

## Features

- Property listing with pagination-ready API requests.
- Property details screen and card-based navigation.
- Favorites and search history persistence with Hive.
- Dynamic theming (`light`, `dark`, `system`) persisted with `SharedPreferences`.
- Feature flags loaded from `assets/feature_flags.json`.
- Performance and usage logging to app data files.
- Accessibility service wiring through DI.
- Offline-friendly behavior via local cache files.

## Tech Stack

- Flutter SDK
- Dart SDK `^3.7.2`
- `flutter_bloc`, `provider`
- `dio`
- `hive`, `hive_flutter`
- `get_it`
- `shared_preferences`
- `path_provider`
- `json_serializable` / `build_runner`
- `mocktail`, `bloc_test`, `integration_test`

## Project Structure

```text
lib/
    core/
        di/                  # dependency injection setup + shared services
        error/               # error models/logging helpers
        feature_flags/       # feature flag loading/usage logging
        performance/         # performance monitoring
        theme/               # theme config and ThemeService
        utils/               # app data path, filters, cache helpers
    data/
        datasources/
            local/             # Hive local data source
            remote/            # Dio API client + interceptors
        models/              # DTOs + generated serialization
        repositories/        # repository implementations
    domain/
        entities/            # domain entities
        repositories/        # repository contracts
        usecases/            # business use cases
    presentation/
        screens/             # UI screens
        viewmodels/          # bloc/provider view models and state/events
        widgets/             # reusable UI widgets
    main.dart              # app entrypoint

assets/
    theme_config.json
    feature_flags.json

test/                    # unit/widget tests
integration_test/        # end-to-end flow tests
```

## Getting Started

### Prerequisites

- Flutter installed and available in `PATH`
- Android Studio or VS Code with Flutter/Dart extensions
- At least one target platform configured (`flutter doctor` should be clean)

### Install

```bash
flutter pub get
```

### Optional: Regenerate Code

Run this if model annotations change or generated files are out of sync:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

### Default

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

### Windows

```bash
flutter run -d windows
```

## Testing and Coverage

### Unit and Widget Tests

```bash
flutter test
```

### Coverage

```bash
flutter test --coverage
```

Coverage output:

- `coverage/lcov.info`

### Integration Tests

```bash
flutter test integration_test
```

Current integration scenario includes a full property list to details flow in `integration_test/property_flow_test.dart`.

## Data and Storage

### Hive Boxes

Initialized in `lib/data/datasources/local/property_database.dart`:

- `properties`
- `favorites`
- `search_history`

### File-Based App Data

App runtime files are written under an app-specific directory resolved by `path_provider` (`getApplicationSupportDirectory`, with temp fallback) via `lib/core/utils/app_data_path.dart`.

Typical files:

- `app_data/feature_usage.json`
- `app_data/api_cache/properties_page_<n>.json`
- `app_data/error_logs.json`
- `app_data/performance_metrics.json`

## Configuration

### Theme Configuration

Theme values are loaded from `assets/theme_config.json` at startup (`AppTheme.init()`).

Required keys per theme block (`light` and `dark`):

- `primary`
- `secondary`
- `background`
- `surface`
- `error`
- `onPrimary`
- `onSecondary`
- `onSurface`

`ThemeService` supports:

- `light`
- `dark`
- `system` (default)

### Feature Flags

Flags are loaded from `assets/feature_flags.json` by `FeatureFlagService`.

Expected format:

```json
{
    "flags": [
        {
            "flagKey": "example_flag",
            "enabled": true,
            "variants": ["default"]
        }
    ]
}
```

## Troubleshooting

### Theme Crash During Startup

If you see a `NoSuchMethodError` around `replaceAll` in theme parsing, verify `assets/theme_config.json` contains the required keys listed above and valid hex colors (for example `#03A9F4`).

### Generated File Mismatch

If build errors mention stale generated files (`*.g.dart`), rerun:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Platform Setup Issues

Run:

```bash
flutter doctor -v
```

and resolve any toolchain or SDK issues reported.

## License

Add your preferred license file (`LICENSE`) and update this section accordingly.
