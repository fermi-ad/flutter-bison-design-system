# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## 0.7.1 2026-08-06

### Fixed

- `BisonChip.filter()`, `.input()`, and `.suggestion()` now correctly branch on the `selected` property.

## 0.7.0 2026-08-03

### Added

- `BisonRadioButton` widget was added to the design system.

### Changed

- `BisonCheckbox` can no longer be checked using the enter key (only space), adhering to the design system specification.

## 0.6.0 2026-07-16

### Added

- `BisonDivider` widget was added to the design system.

## 0.5.0 2026-07-02

### Added

- `BisonCheckbox` widget was added to the design system.

### Changed

- **Breaking** `BisonSwitch.onChanged` now receives the current value instead of the next toggled value; consumers must compute and set the next state.

## 0.4.1 2026-06-29

### Changed

- `BisonMenu` has a more prominent box-shadow.

### Fixed

- AppBar background does not change color on scroll,

## 0.4.0 2026-06-26

### Added

- `BisonSwitch` widget was added to the design system.
- Provided a default AppBar theming.

## 0.3.0 2026-06-05

### Added

- `BisonTextField` widget was added to the design system.
- A `BisonScrim` Use Case was added to the widgetbook.

### Changed

- Added the 'rightIcon' property field to `BisonButton`
  - **Breaking**: the 'icon' property field was renamed 'leftIcon' to accommodate 'rightIcon'.

## 0.0.1

- TODO: Describe initial release.
