# Design System Catalog

A Flutter Widgetbook catalog to view and test design system components.

## Widgetbook

Widgetbook is an interactive component catalog for previewing, testing, and reviewing design-system widgets in isolation.

View the internal hosted instance: [Widgetbook](https://ad-apps-internal.fnal.gov/design-system/)

## Getting Started

Install dependencies:

```sh
flutter pub get
```

Generate Widgetbook directories and use cases:

```sh
dart run build_runner build
```

Start up the Widgetbook:

```sh
flutter run -d web-server --web-port=5037
```

If you add new components or use cases, don't forget to rerun the build_runner command.

## Widgetbook Cloud

Widgetbook Cloud is our design review mechanism for the component catalog. It lets us visually inspect component states and compare catalog changes in a hosted environment.

In CI, the Widgetbook Cloud workflow builds the catalog and checks coverage so missing use cases or components fail early on pull requests.

To see whether your PR will pass the Widgetbook CI check, run this coverage check from the repo root:

```sh
# One-time setup
dart pub global activate widgetbook_cli

# Run the check
dart pub global run widgetbook_cli:widgetbook coverage --package ./ --widgetbook ./example
```

This uses the same coverage command as the GitHub Action gate.
