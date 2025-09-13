# Tasks for Self-Discipline App

**Feature**: Self-Discipline Point System App
**Branch**: `001-app-7-7`

This document outlines the development tasks for creating the self-discipline app. The tasks are ordered by dependency, following a Test-Driven Development (TDD) approach.

---

## Phase 1: Project Setup

**T001: Initialize Flutter Project**
- **Action**: Create a new Flutter project named `zilv`.
- **Command**: `flutter create zilv`
- **Files**: Entire new project directory.

**T002: Add Dependencies**
- **Action**: Add the required dependencies to `pubspec.yaml`.
- **Dependencies**: `sqflite`, `path`, `provider`, `flutter_local_notifications`.
- **Files**: `pubspec.yaml`

**T003: Configure Linting**
- **Action**: Set up strict linting rules to ensure code quality.
- **Files**: `analysis_options.yaml`

**T004: Create Directory Structure**
- **Action**: Create the directory structure as defined in the implementation plan.
- **Structure**: `lib/src/models`, `lib/src/services`, `lib/src/ui/home`, `lib/src/ui/behaviors`, `lib/src/ui/settings`, `test/services`, `test/ui`.

---

## Phase 2: Data Models & Database

**T005: Create Data Model Classes [P]**
- **Action**: Create the Dart classes for each entity defined in `data-model.md`.
- **Files**:
  - `lib/src/models/user.dart`
  - `lib/src/models/behavior.dart`
  - `lib/src/models/log_entry.dart`
  - `lib/src/models/reminder.dart`
- **Note**: These can be created in parallel.

**T006: Implement Database Helper**
- **Action**: Create a singleton class to manage the SQLite database connection, creation, and table setup.
- **Files**: `lib/src/services/database_helper.dart`
- **Dependencies**: T005

---

## Phase 3: Business Logic (Services)

**T007: Define Service Contracts**
- **Action**: Create the abstract classes for `BehaviorService` and `ReminderService` as defined in `contracts/services.md`.
- **Files**:
  - `lib/src/services/behavior_service.dart`
  - `lib/src/services/reminder_service.dart`
- **Dependencies**: T005

**T008: Write Failing Tests for BehaviorService**
- **Action**: Write unit tests for `BehaviorService` that cover all methods defined in the contract. These tests should fail initially.
- **Files**: `test/services/behavior_service_test.dart`
- **Dependencies**: T006, T007

**T009: Implement BehaviorService**
- **Action**: Write the concrete implementation of `BehaviorService` to make the tests in T008 pass.
- **Files**: `lib/src/services/behavior_service.dart`
- **Dependencies**: T008

**T010: Write Failing Tests for ReminderService**
- **Action**: Write unit tests for `ReminderService`.
- **Files**: `test/services/reminder_service_test.dart`
- **Dependencies**: T007

**T011: Implement ReminderService**
- **Action**: Write the concrete implementation of `ReminderService` to make the tests in T010 pass.
- **Files**: `lib/src/services/reminder_service.dart`
- **Dependencies**: T010

---

## Phase 4: User Interface

**T012: Set up State Management**
- **Action**: Configure `ChangeNotifierProvider` in `main.dart` to provide the services to the widget tree.
- **Files**: `lib/main.dart`
- **Dependencies**: T009, T011

**T013: Build Home Screen UI**
- **Action**: Create the UI for the home screen, displaying the current score and the list of behavior tags. This is UI only, no logic yet.
- **Files**: `lib/src/ui/home/home_screen.dart`

**T014: Connect Home Screen to BehaviorService**
- **Action**: Use `Provider` to connect the `HomeScreen` to the `BehaviorService`. Implement the logic for fetching behaviors and logging them when a tag is tapped.
- **Files**: `lib/src/ui/home/home_screen.dart`
- **Dependencies**: T012, T013

**T015: Build Behavior Management Screen UI**
- **Action**: Create the UI for adding, editing, and deleting behaviors.
- **Files**: `lib/src/ui/behaviors/manage_behaviors_screen.dart`

**T016: Connect Behavior Management Screen to Service**
- **Action**: Implement the logic to add, update, and delete behaviors using the `BehaviorService`.
- **Files**: `lib/src/ui/behaviors/manage_behaviors_screen.dart`
- **Dependencies**: T012, T015

**T017: Build Settings Screen UI**
- **Action**: Create the UI for configuring reminders.
- **Files**: `lib/src/ui/settings/settings_screen.dart`

**T018: Connect Settings Screen to ReminderService**
- **Action**: Implement the logic to save and update reminder settings.
- **Files**: `lib/src/ui/settings/settings_screen.dart`
- **Dependencies**: T012, T017

---

## Phase 5: Integration & Polish

**T019: Implement Local Notifications**
- **Action**: Integrate the `flutter_local_notifications` package with the `ReminderService` to schedule and trigger notifications.
- **Files**: `lib/src/services/reminder_service.dart`
- **Dependencies**: T011

**T020: Write Integration Tests [P]**
- **Action**: Create integration tests based on the scenarios in `quickstart.md`.
- **Files**: `integration_test/app_test.dart`
- **Dependencies**: T014, T016, T018

**T021: Code Documentation and Cleanup**
- **Action**: Add comments to public methods and classes. Run `dart format` and fix any analyzer warnings.
- **Files**: All `.dart` files.

---

## Parallel Execution Examples

The following tasks can be executed in parallel.

**Example 1: Create Models**
```bash
# Terminal 1
task-agent execute T005 --file lib/src/models/user.dart

# Terminal 2
task-agent execute T005 --file lib/src/models/behavior.dart

# Terminal 3
task-agent execute T005 --file lib/src/models/log_entry.dart
```

**Example 2: Write Service Tests and Integration Tests (after services are defined)**
```bash
# Terminal 1
task-agent execute T008

# Terminal 2
task-agent execute T010

# Terminal 3
task-agent execute T020
```
