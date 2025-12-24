# Camaroo Project - Detailed Issues, Tasks, and Sub-tasks

This document provides a comprehensive breakdown of all project phases, epics, features, tasks, and sub-tasks for the Camaroo camera application. Each item includes detailed implementation notes and code context based on the MVC architecture established in the dev branch.

## Architecture Overview

The project follows an MVC (Model-View-Controller) pattern with the following structure:
- **Controllers (Adapters)**: Business logic in `lib/adapters/` - handle state and orchestrate between models and views
- **Models**: Data structures in `lib/core/models/` and interfaces in `lib/core/abstractions/`
- **Views (UI)**: Presentation layer in `lib/ui/` - widgets and screens
- **Plugin Wrappers**: Platform-specific code and plugin integration in `lib/ui/<feature>/widgets/`
- **Utils**: Shared utilities in `lib/utils/`

Example from existing code:
```dart
// lib/core/abstractions/home_api.dart - Interface
abstract class HomeApi {
  int get counter;
  void setCounter(int value);
  Function(int) onCounterChanged = (value) {};
}

// lib/core/models/home_model.dart - Model implementation
class HomeApiModel implements HomeApi {
  int _counter = 0;
  @override
  int get counter => _counter;
  @override
  void setCounter(int value) {
    _counter = value;
    onCounterChanged(value);
  }
}

// lib/adapters/home_adapter.dart - Controller
class HomeAdapter {
  HomeAdapter(HomeApi homeApi) {
    counterNotifier = ValueNotifier(homeApi.counter);
    homeApi.onCounterChanged = (value) => counterNotifier.value = value;
  }
  late final ValueNotifier<int> counterNotifier;
}

// lib/ui/home.dart - View
class HomePage extends StatefulWidget {
  final HomeApi homeApi = HomeApiModel();
  late final HomeAdapter homeAdapter = HomeAdapter(homeApi);
  // UI uses ValueListenableBuilder with homeAdapter.counterNotifier
}
```

---

## Phase 1: Foundation & Core Capture (MVP)
**Status**: Issue #4 exists
**Goal**: Establish robust infrastructure and deliver MVP with core camera functionality and basic gallery

---

### Epic 1: Infrastructure & Architecture
**Status**: Issue #5 exists
**Goal**: Establish foundation and architecture for scalable, testable camera/gallery app

---

#### Feature 1.1: Project Scaffold (Flutter env, CI/CD, linting)
**Status**: Issue #6 exists
**Related Issues**: #12 (Setup), #13 (Linting), #14 (CI/CD)

##### Task 1.1.1: Setup and structure Flutter project
**Status**: Issue #12 exists - UPDATE THIS ISSUE WITH SUBTASKS BELOW

**Subtasks to add to Issue #12:**

###### Subtask 1.1.1.1: Verify and document directory structure
- **Description**: Ensure all required directories exist and are properly documented
- **Files to verify**:
  - `lib/adapters/` - for all controller code
  - `lib/core/models/` - for model implementations
  - `lib/core/abstractions/` - for interfaces/abstract classes
  - `lib/ui/` - for all view widgets and screens
  - `lib/utils/` - for utilities (app_constants.dart, theme_constants.dart already exist)
- **Action**: Add `.gitkeep` files where needed, update README with structure explanation
- **Architecture note**: Each feature should have its adapter in `lib/adapters/<feature>/`, models in `lib/core/models/<feature>/`, and UI in `lib/ui/<feature>/`

###### Subtask 1.1.1.2: Create feature-specific directory structure
- **Description**: Set up directories for upcoming features
- **Directories to create**:
  - `lib/adapters/camera/` - camera controller logic
  - `lib/adapters/gallery/` - gallery controller logic
  - `lib/adapters/permissions/` - permission handling logic
  - `lib/core/models/camera/` - camera-related models
  - `lib/core/models/gallery/` - photo/album models
  - `lib/core/models/permissions/` - permission state models
  - `lib/core/abstractions/camera/` - camera interfaces
  - `lib/core/abstractions/gallery/` - gallery interfaces
  - `lib/core/abstractions/permissions/` - permission interfaces
  - `lib/ui/camera/` - camera screens and widgets
  - `lib/ui/camera/widgets/` - reusable camera widgets and plugin wrappers
  - `lib/ui/gallery/` - gallery screens and widgets
  - `lib/ui/gallery/widgets/` - reusable gallery widgets
- **Action**: Create directories with placeholder README.md files explaining their purpose

###### Subtask 1.1.1.3: Update root README with architecture documentation
- **Description**: Document the MVC architecture pattern and conventions
- **Content to add**:
  - Explanation of MVC pattern used
  - Directory structure with examples
  - How to add new features (create adapter, model, abstraction, and UI)
  - State management approach (ValueNotifier pattern shown in home example)
  - Plugin wrapper convention (place in `lib/ui/<feature>/widgets/`)
  - Code style guidelines
- **Reference**: Use existing home example as a template

###### Subtask 1.1.1.4: Verify and document dependencies
- **Description**: Ensure pubspec.yaml has all necessary initial dependencies
- **Current dependencies**:
  - flutter SDK
  - cupertino_icons: ^1.0.8
- **Dev dependencies**:
  - flutter_test
  - flutter_lints: ^6.0.0
- **Action**: Document dependency management process in README, explain pub get workflow

###### Subtask 1.1.1.5: Create project conventions document
- **Description**: Create CONTRIBUTING.md with development guidelines
- **Content to include**:
  - How to set up development environment
  - How to run the app locally
  - Code organization patterns
  - Naming conventions (e.g., `<feature>_adapter.dart`, `<feature>_model.dart`, `<feature>_api.dart`)
  - Testing requirements
  - PR submission process
  - Architecture decision records (ADR) for MVC choice

---

##### Task 1.1.2: Configure linting, formatting, and code standards
**Status**: Issue #13 exists - UPDATE THIS ISSUE WITH SUBTASKS BELOW

**Subtasks to add to Issue #13:**

###### Subtask 1.1.2.1: Review and enhance analysis_options.yaml
- **Description**: Ensure comprehensive linting rules are configured
- **Current file**: `analysis_options.yaml` already exists
- **Rules to add/verify**:
  ```yaml
  linter:
    rules:
      - always_declare_return_types
      - always_require_non_null_named_parameters
      - annotate_overrides
      - avoid_print
      - avoid_relative_lib_imports
      - avoid_return_types_on_setters
      - avoid_types_as_parameter_names
      - camel_case_types
      - prefer_const_constructors
      - prefer_const_declarations
      - prefer_final_fields
      - prefer_final_locals
      - require_trailing_commas
      - sort_constructors_first
      - use_key_in_widget_constructors
  ```
- **Action**: Update file, document any project-specific rule exceptions

###### Subtask 1.1.2.2: Add formatting configuration
- **Description**: Configure dart format settings
- **Actions**:
  - Add `.editorconfig` for IDE consistency
  - Set line length to 80 or 120 (decide and document)
  - Configure trailing commas for better diffs
- **Example .editorconfig**:
  ```ini
  [*.dart]
  indent_style = space
  indent_size = 2
  max_line_length = 80
  ```

###### Subtask 1.1.2.3: Create formatting and linting scripts
- **Description**: Add helper scripts for developers
- **Scripts to add in pubspec.yaml** or as shell scripts:
  - `dart format .` - format all code
  - `dart analyze` - run static analysis
  - `flutter test` - run all tests
- **Action**: Document these commands in CONTRIBUTING.md

###### Subtask 1.1.2.4: Set up pre-commit hooks (optional)
- **Description**: Automate linting/formatting checks before commit
- **Tool**: Consider using `lefthook` or Git hooks
- **Hook should**:
  - Run `dart format --set-exit-if-changed .`
  - Run `dart analyze --fatal-infos`
  - Block commit if checks fail
- **Action**: Add setup instructions to CONTRIBUTING.md

###### Subtask 1.1.2.5: Validate linting on existing code
- **Description**: Ensure current codebase passes all linting rules
- **Commands to run**:
  ```bash
  dart format --set-exit-if-changed .
  dart analyze --fatal-infos
  ```
- **Action**: Fix any issues found, document exceptions if needed

---

##### Task 1.1.3: Implement CI/CD pipeline
**Status**: Issue #14 exists - UPDATE THIS ISSUE WITH SUBTASKS BELOW

**Subtasks to add to Issue #14:**

###### Subtask 1.1.3.1: Create GitHub Actions workflow file
- **Description**: Set up CI/CD automation
- **File to create**: `.github/workflows/flutter.yml`
- **Workflow structure**:
  ```yaml
  name: Flutter CI
  
  on:
    push:
      branches: [ main, dev ]
    pull_request:
      branches: [ main, dev ]
  
  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        - uses: subosito/flutter-action@v2
          with:
            flutter-version: '3.10.4'
            channel: 'stable'
        - name: Install dependencies
          run: flutter pub get
        - name: Verify formatting
          run: dart format --set-exit-if-changed .
        - name: Analyze code
          run: dart analyze --fatal-infos
        - name: Run tests
          run: flutter test
  ```

###### Subtask 1.1.3.2: Add dependency caching
- **Description**: Speed up CI runs by caching pub dependencies
- **Action**: Add cache step to workflow:
  ```yaml
  - name: Cache pub dependencies
    uses: actions/cache@v3
    with:
      path: |
        ${{ env.PUB_CACHE }}
        **/.dart_tool
      key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
      restore-keys: |
        ${{ runner.os }}-pub-
  ```

###### Subtask 1.1.3.3: Add build validation steps
- **Description**: Ensure app builds successfully for all platforms
- **Actions to add**:
  ```yaml
  - name: Build Android APK
    run: flutter build apk --debug
  - name: Build iOS (dry run)
    run: flutter build ios --debug --no-codesign
  ```
- **Note**: iOS build might need macOS runner for full build

###### Subtask 1.1.3.4: Configure status checks for PRs
- **Description**: Require CI to pass before merging
- **Action**: Configure branch protection rules in GitHub repo settings
- **Settings**:
  - Require status checks to pass before merging
  - Require branches to be up to date before merging
  - Require Flutter CI to pass

###### Subtask 1.1.3.5: Add CI badges to README
- **Description**: Show build status in repository
- **Badge to add**:
  ```markdown
  ![Flutter CI](https://github.com/harisrovca/camaroo/workflows/Flutter%20CI/badge.svg)
  ```
- **Action**: Update README.md with badge and CI documentation

###### Subtask 1.1.3.6: Document CI/CD troubleshooting
- **Description**: Help contributors debug CI failures
- **Content to add to README or CONTRIBUTING.md**:
  - How to view CI logs
  - Common failure scenarios and fixes
  - How to run CI checks locally
  - Contact info for CI issues

---

#### Feature 1.2: State Management Setup (MVC controller logic)
**Status**: Issue #7 exists - ADD SUBTASKS

##### Task 1.2.1: Define state management architecture
**New Task** - Create as sub-issue of #7

**Description**: Document and establish state management patterns across the app

**Subtasks**:

###### Subtask 1.2.1.1: Document ValueNotifier pattern
- **Description**: Create architecture documentation for state management
- **File to create**: `docs/STATE_MANAGEMENT.md`
- **Content**:
  - Explain ValueNotifier approach (as seen in HomeAdapter)
  - When to use ValueNotifier vs setState
  - How adapters expose state to UI
  - Examples from home counter implementation
  - Guidelines for complex state (nested notifiers, combining states)

###### Subtask 1.2.1.2: Define state classes structure
- **Description**: Create base classes/patterns for consistent state handling
- **Files to create**:
  - `lib/core/abstractions/base_adapter.dart` - optional base adapter class
  - `lib/core/models/app_state.dart` - global app state if needed
- **Pattern to follow**:
  ```dart
  // Each feature adapter follows this pattern:
  class FeatureAdapter {
    FeatureAdapter(FeatureApi api) {
      // Initialize notifiers
      // Set up listeners
    }
    
    // Expose ValueNotifiers for UI
    late final ValueNotifier<FeatureState> stateNotifier;
    
    // Expose actions
    void performAction() {
      // Call API methods
      // Update state via notifiers
    }
    
    void dispose() {
      // Clean up notifiers
    }
  }
  ```

###### Subtask 1.2.1.3: Plan camera state machine
- **Description**: Define states and transitions for camera feature
- **States to define**:
  - Uninitialized
  - Initializing
  - Ready
  - Capturing
  - Error
  - Disposed
- **Transitions**:
  - Uninitialized -> Initializing (when permissions granted)
  - Initializing -> Ready (when camera initialized)
  - Ready -> Capturing (when capture button pressed)
  - Capturing -> Ready (when capture complete)
  - Any -> Error (on failure)
  - Any -> Disposed (on cleanup)
- **File to create**: `docs/CAMERA_STATE_MACHINE.md` with state diagram

###### Subtask 1.2.1.4: Plan gallery state management
- **Description**: Define state structure for gallery/photos
- **State elements**:
  - List of photos (paginated)
  - Current album filter
  - Selected photos (for multi-select)
  - Loading states
  - Error states
- **Architecture**:
  ```dart
  class GalleryAdapter {
    late final ValueNotifier<List<Photo>> photosNotifier;
    late final ValueNotifier<bool> isLoadingNotifier;
    late final ValueNotifier<Set<String>> selectedPhotoIdsNotifier;
    late final ValueNotifier<Album?> currentAlbumNotifier;
  }
  ```

###### Subtask 1.2.1.5: Create state management testing guide
- **Description**: Document how to test adapters and state
- **Content for `docs/TESTING_STATE.md`**:
  - Unit testing adapters
  - Mocking API implementations
  - Testing state transitions
  - Widget testing with adapters
  - Example test from HomeAdapter

---

##### Task 1.2.2: Implement base state utilities
**New Task** - Create as sub-issue of #7

**Description**: Create reusable utilities for state management

**Subtasks**:

###### Subtask 1.2.2.1: Create async state wrapper
- **Description**: Handle loading/error/success states consistently
- **File to create**: `lib/core/models/async_state.dart`
- **Implementation**:
  ```dart
  enum AsyncStatus { idle, loading, success, error }
  
  class AsyncState<T> {
    final AsyncStatus status;
    final T? data;
    final String? error;
    
    const AsyncState.idle() : status = AsyncStatus.idle, data = null, error = null;
    const AsyncState.loading() : status = AsyncStatus.loading, data = null, error = null;
    const AsyncState.success(this.data) : status = AsyncStatus.success, error = null;
    const AsyncState.error(this.error) : status = AsyncStatus.error, data = null;
    
    bool get isLoading => status == AsyncStatus.loading;
    bool get isSuccess => status == AsyncStatus.success;
    bool get isError => status == AsyncStatus.error;
  }
  ```

###### Subtask 1.2.2.2: Create disposable mixin
- **Description**: Standardize cleanup across adapters
- **File to create**: `lib/core/abstractions/disposable.dart`
- **Implementation**:
  ```dart
  mixin Disposable {
    final List<ValueNotifier> _notifiers = [];
    
    void registerNotifier(ValueNotifier notifier) {
      _notifiers.add(notifier);
    }
    
    void dispose() {
      for (var notifier in _notifiers) {
        notifier.dispose();
      }
      _notifiers.clear();
    }
  }
  ```

###### Subtask 1.2.2.3: Create combined notifier utilities
- **Description**: Combine multiple notifiers into one
- **File to create**: `lib/utils/notifier_utils.dart`
- **Use case**: When UI needs to rebuild on multiple state changes

---

#### Feature 1.3: Permission Manager
**Status**: Issue #8 exists - ADD TASKS AND SUBTASKS

##### Task 1.3.1: Design permission architecture
**New Task** - Create as sub-issue of #8

**Subtasks**:

###### Subtask 1.3.1.1: Create permission abstraction
- **Description**: Define permission interface
- **File to create**: `lib/core/abstractions/permissions/permission_api.dart`
- **Implementation**:
  ```dart
  enum PermissionType {
    camera,
    microphone,
    storage,
    location,
  }
  
  enum PermissionStatus {
    notDetermined,
    granted,
    denied,
    permanentlyDenied,
  }
  
  abstract class PermissionApi {
    Future<PermissionStatus> checkPermission(PermissionType type);
    Future<PermissionStatus> requestPermission(PermissionType type);
    Future<Map<PermissionType, PermissionStatus>> requestMultiplePermissions(List<PermissionType> types);
    Future<bool> openAppSettings();
  }
  ```

###### Subtask 1.3.1.2: Create permission model
- **Description**: Implement permission handling
- **File to create**: `lib/core/models/permissions/permission_model.dart`
- **Note**: Will use `permission_handler` plugin (add to pubspec.yaml)
- **Implementation**: Wrap permission_handler plugin methods

###### Subtask 1.3.1.3: Create permission adapter
- **Description**: Controller for permission state
- **File to create**: `lib/adapters/permissions/permission_adapter.dart`
- **State to expose**:
  ```dart
  class PermissionAdapter with Disposable {
    late final ValueNotifier<Map<PermissionType, PermissionStatus>> permissionsNotifier;
    
    Future<void> requestCameraPermissions() async {
      // Request camera and microphone
    }
    
    Future<void> requestStoragePermissions() async {
      // Request storage access
    }
    
    bool get hasCameraPermission => /* check state */;
    bool get hasStoragePermission => /* check state */;
  }
  ```

---

##### Task 1.3.2: Implement permission UI flows
**New Task** - Create as sub-issue of #8

**Subtasks**:

###### Subtask 1.3.2.1: Create permission request widget
- **Description**: Reusable widget for permission requests
- **File to create**: `lib/ui/permissions/widgets/permission_request_widget.dart`
- **Features**:
  - Show permission rationale
  - Request button
  - Handle denied/permanently denied states
  - Open settings button for permanently denied

###### Subtask 1.3.2.2: Create permission gate widget
- **Description**: Conditional wrapper that checks permissions
- **File to create**: `lib/ui/permissions/widgets/permission_gate.dart`
- **Usage**:
  ```dart
  PermissionGate(
    permissions: [PermissionType.camera],
    child: CameraScreen(),
    onPermissionDenied: () => /* show rationale */,
  )
  ```

###### Subtask 1.3.2.3: Add permission strings to constants
- **Description**: User-facing permission messages
- **File to update**: `lib/utils/app_constants.dart`
- **Add**:
  ```dart
  static const String cameraPermissionRationale = 
    "Camera access is required to take photos";
  static const String storagePermissionRationale = 
    "Storage access is required to save and view photos";
  ```

---

##### Task 1.3.3: Handle permission edge cases
**New Task** - Create as sub-issue of #8

**Subtasks**:

###### Subtask 1.3.3.1: Handle permanently denied permissions
- **Description**: Show UI to guide users to settings
- **Action**: Create dialog that explains how to enable in settings
- **File**: `lib/ui/permissions/widgets/settings_dialog.dart`

###### Subtask 1.3.3.2: Handle permission restoration on app resume
- **Description**: Check permissions when app comes to foreground
- **Implementation**: Add WidgetsBindingObserver to permission adapter

###### Subtask 1.3.3.3: Add permission error handling
- **Description**: Handle permission API errors gracefully
- **Error scenarios**:
  - Plugin not available
  - Platform not supported
  - User cancels permission dialog

---

##### Task 1.3.4: Test permission flows
**New Task** - Create as sub-issue of #8

**Subtasks**:

###### Subtask 1.3.4.1: Unit test permission adapter
- **File**: `test/adapters/permissions/permission_adapter_test.dart`
- **Test cases**:
  - Permission status changes
  - Multiple permission requests
  - Settings navigation

###### Subtask 1.3.4.2: Widget test permission UI
- **File**: `test/ui/permissions/permission_widget_test.dart`
- **Test cases**:
  - Permission request dialog appears
  - Denied state shows rationale
  - Settings button works

###### Subtask 1.3.4.3: Integration test permission flow
- **File**: `test/integration/permission_flow_test.dart`
- **Test**: Complete flow from request to granted/denied

---

#### Feature 1.4: Local Database (photo/album metadata)
**Status**: Issue #9 exists - ADD TASKS AND SUBTASKS

##### Task 1.4.1: Design database schema
**New Task** - Create as sub-issue of #9

**Subtasks**:

###### Subtask 1.4.1.1: Define Photo entity
- **Description**: Schema for photo metadata
- **File to create**: `lib/core/models/gallery/photo.dart`
- **Fields**:
  ```dart
  class Photo {
    final String id;            // UUID
    final String filePath;      // Local file path
    final DateTime capturedAt;  // Capture timestamp
    final DateTime createdAt;   // DB record creation
    final DateTime? modifiedAt; // Last edit timestamp
    final int width;
    final int height;
    final int fileSize;         // Bytes
    final String? mimeType;     // image/jpeg, etc
    final double? latitude;
    final double? longitude;
    final List<String> tags;    // AI-generated tags
    final Map<String, dynamic>? metadata; // EXIF data
    final bool isFavorite;
    final String? albumId;      // Foreign key
  }
  ```

###### Subtask 1.4.1.2: Define Album entity
- **Description**: Schema for photo albums
- **File to create**: `lib/core/models/gallery/album.dart`
- **Fields**:
  ```dart
  class Album {
    final String id;
    final String name;
    final String? description;
    final DateTime createdAt;
    final DateTime modifiedAt;
    final String? coverPhotoId;  // Reference to Photo
    final int photoCount;        // Denormalized for performance
  }
  ```

###### Subtask 1.4.1.3: Create database schema SQL
- **Description**: Define database tables
- **File to create**: `lib/core/models/gallery/schema.dart`
- **Tables**:
  ```sql
  CREATE TABLE photos (
    id TEXT PRIMARY KEY,
    file_path TEXT NOT NULL,
    captured_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    modified_at INTEGER,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    file_size INTEGER NOT NULL,
    mime_type TEXT,
    latitude REAL,
    longitude REAL,
    tags TEXT,  -- JSON array
    metadata TEXT,  -- JSON object
    is_favorite INTEGER DEFAULT 0,
    album_id TEXT,
    FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE SET NULL
  );
  
  CREATE TABLE albums (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    created_at INTEGER NOT NULL,
    modified_at INTEGER NOT NULL,
    cover_photo_id TEXT,
    photo_count INTEGER DEFAULT 0,
    FOREIGN KEY (cover_photo_id) REFERENCES photos(id) ON DELETE SET NULL
  );
  
  CREATE INDEX idx_photos_captured_at ON photos(captured_at DESC);
  CREATE INDEX idx_photos_album_id ON photos(album_id);
  CREATE INDEX idx_photos_favorite ON photos(is_favorite);
  ```

---

##### Task 1.4.2: Implement database layer
**New Task** - Create as sub-issue of #9

**Subtasks**:

###### Subtask 1.4.2.1: Create database abstraction
- **Description**: Define database interface
- **File to create**: `lib/core/abstractions/gallery/database_api.dart`
- **Methods**:
  ```dart
  abstract class DatabaseApi {
    Future<void> initialize();
    Future<void> close();
    
    // Photos
    Future<String> insertPhoto(Photo photo);
    Future<Photo?> getPhoto(String id);
    Future<List<Photo>> getPhotos({int limit, int offset, String? albumId});
    Future<void> updatePhoto(Photo photo);
    Future<void> deletePhoto(String id);
    Future<List<Photo>> searchPhotos(String query);
    
    // Albums
    Future<String> insertAlbum(Album album);
    Future<Album?> getAlbum(String id);
    Future<List<Album>> getAlbums();
    Future<void> updateAlbum(Album album);
    Future<void> deleteAlbum(String id);
  }
  ```

###### Subtask 1.4.2.2: Implement database with sqflite
- **Description**: SQLite implementation
- **File to create**: `lib/core/models/gallery/database_model.dart`
- **Dependencies**: Add `sqflite` and `path` to pubspec.yaml
- **Implementation**: 
  - Open/create database
  - Execute schema
  - Implement CRUD methods
  - Handle migrations

###### Subtask 1.4.2.3: Add database migration system
- **Description**: Handle schema changes across versions
- **File to create**: `lib/core/models/gallery/migrations.dart`
- **Pattern**:
  ```dart
  final migrations = {
    1: (Database db) async {
      // Initial schema
      await db.execute(/* CREATE TABLE photos */);
      await db.execute(/* CREATE TABLE albums */);
    },
    2: (Database db) async {
      // Future migration
      // await db.execute(/* ALTER TABLE ... */);
    },
  };
  ```

###### Subtask 1.4.2.4: Add database service wrapper
- **Description**: Plugin wrapper for database
- **File to create**: `lib/ui/gallery/widgets/database_service.dart`
- **Purpose**: Initialize database when app starts, provide singleton access

---

##### Task 1.4.3: Implement gallery adapter with database
**New Task** - Create as sub-issue of #9

**Subtasks**:

###### Subtask 1.4.3.1: Create gallery adapter
- **Description**: Controller for gallery state with DB backing
- **File to create**: `lib/adapters/gallery/gallery_adapter.dart`
- **State**:
  ```dart
  class GalleryAdapter with Disposable {
    final DatabaseApi _db;
    
    late final ValueNotifier<AsyncState<List<Photo>>> photosNotifier;
    late final ValueNotifier<AsyncState<List<Album>>> albumsNotifier;
    late final ValueNotifier<Set<String>> selectedPhotoIdsNotifier;
    
    Future<void> loadPhotos({String? albumId}) async {
      photosNotifier.value = AsyncState.loading();
      try {
        final photos = await _db.getPhotos(albumId: albumId);
        photosNotifier.value = AsyncState.success(photos);
      } catch (e) {
        photosNotifier.value = AsyncState.error(e.toString());
      }
    }
    
    Future<void> createAlbum(String name) async { /* ... */ }
    Future<void> addPhotoToAlbum(String photoId, String albumId) async { /* ... */ }
    Future<void> toggleFavorite(String photoId) async { /* ... */ }
  }
  ```

###### Subtask 1.4.3.2: Add photo indexing logic
- **Description**: Scan device for photos and add to DB
- **Method**: `Future<void> indexDevicePhotos()`
- **Plugin needed**: `photo_manager` for accessing device photos
- **Process**:
  1. Request permissions
  2. Use photo_manager to get device photos
  3. For each photo, create Photo record in DB
  4. Update progress notifier

###### Subtask 1.4.3.3: Add photo cleanup logic
- **Description**: Remove DB records for deleted files
- **Method**: `Future<void> cleanupDeletedPhotos()`
- **Process**:
  1. Get all photo records from DB
  2. Check if file exists
  3. Remove record if file missing

---

##### Task 1.4.4: Test database layer
**New Task** - Create as sub-issue of #9

**Subtasks**:

###### Subtask 1.4.4.1: Unit test database model
- **File**: `test/core/models/gallery/database_model_test.dart`
- **Test cases**:
  - CRUD operations for photos
  - CRUD operations for albums
  - Queries with filters
  - Foreign key constraints

###### Subtask 1.4.4.2: Unit test gallery adapter
- **File**: `test/adapters/gallery/gallery_adapter_test.dart`
- **Test cases**:
  - Load photos
  - Create album
  - Add photo to album
  - Toggle favorite

###### Subtask 1.4.4.3: Integration test with real database
- **File**: `test/integration/database_integration_test.dart`
- **Test**: Complete gallery flow with actual SQLite database

---

### Epic 2: The Viewfinder (Basic Camera)
**Status**: Issue #10 exists - ADD FEATURE TASKS

**Description**: Implement high-performance, stable camera viewfinder with core features

**Features to add as separate tasks/sub-issues:**

---

#### Feature 2.1: Camera Preview
**New Feature** - Create as sub-issue of #10

##### Task 2.1.1: Set up camera plugin and permissions
**Subtasks**:

###### Subtask 2.1.1.1: Add camera plugin dependency
- **Action**: Add `camera` plugin to pubspec.yaml
- **Version**: Latest stable version
- **Also add**: `path_provider` for file storage

###### Subtask 2.1.1.2: Configure Android permissions
- **File**: `android/app/src/main/AndroidManifest.xml`
- **Add**:
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-feature android:name="android.hardware.camera" />
  <uses-feature android:name="android.hardware.camera.autofocus" />
  ```

###### Subtask 2.1.1.3: Configure iOS permissions
- **File**: `ios/Runner/Info.plist`
- **Add**:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Camera access is required to take photos and videos</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Microphone access is required to record audio</string>
  ```

---

##### Task 2.1.2: Create camera abstraction layer
**Subtasks**:

###### Subtask 2.1.2.1: Define camera API interface
- **File**: `lib/core/abstractions/camera/camera_api.dart`
- **Interface**:
  ```dart
  enum CameraState { uninitialized, initializing, ready, capturing, error, disposed }
  enum CameraLensDirection { front, back, external }
  
  abstract class CameraApi {
    CameraState get state;
    List<CameraDescription> get availableCameras;
    CameraDescription? get currentCamera;
    
    Future<void> initialize();
    Future<void> selectCamera(CameraDescription camera);
    Future<void> startPreview();
    Future<void> stopPreview();
    Future<String> takePicture();
    Future<void> dispose();
    
    Stream<CameraState> get stateStream;
  }
  ```

###### Subtask 2.1.2.2: Create camera model implementation
- **File**: `lib/core/models/camera/camera_model.dart`
- **Implementation**:
  - Wrap `camera` plugin
  - Handle CameraController lifecycle
  - Implement state machine
  - Error handling and recovery

---

##### Task 2.1.3: Create camera adapter
**Subtasks**:

###### Subtask 2.1.3.1: Implement camera adapter
- **File**: `lib/adapters/camera/camera_adapter.dart`
- **State to expose**:
  ```dart
  class CameraAdapter with Disposable {
    final CameraApi _cameraApi;
    
    late final ValueNotifier<CameraState> stateNotifier;
    late final ValueNotifier<CameraController?> controllerNotifier;
    late final ValueNotifier<String?> errorNotifier;
    late final ValueNotifier<CameraLensDirection> lensDirectionNotifier;
    
    Future<void> initializeCamera() async { /* ... */ }
    Future<void> toggleCamera() async { /* ... */ }
    Future<String> capturePhoto() async { /* ... */ }
  }
  ```

---

##### Task 2.1.4: Create camera preview UI
**Subtasks**:

###### Subtask 2.1.4.1: Create camera screen
- **File**: `lib/ui/camera/camera_screen.dart`
- **Layout**:
  - Full-screen camera preview
  - Capture button (bottom center)
  - Toggle camera button (top right)
  - Flash control button (top left)
  - Back button (top left)

###### Subtask 2.1.4.2: Create camera preview widget
- **File**: `lib/ui/camera/widgets/camera_preview_widget.dart`
- **Features**:
  - Display CameraPreview from controller
  - Handle aspect ratio
  - Show loading indicator during initialization
  - Show error message if initialization fails

###### Subtask 2.1.4.3: Add camera lifecycle handling
- **Description**: Properly handle pause/resume
- **Implementation**: Use WidgetsBindingObserver in camera screen
- **Actions**:
  - Pause camera when app goes to background
  - Resume camera when app comes to foreground
  - Dispose camera when screen is disposed

---

#### Feature 2.2: Capture Engine (JPEG)
**New Feature** - Create as sub-issue of #10

##### Task 2.2.1: Implement photo capture
**Subtasks**:

###### Subtask 2.2.1.1: Add capture method to camera API
- **Method**: `Future<String> takePicture()`
- **Returns**: File path of captured image
- **Implementation**:
  - Use CameraController.takePicture()
  - Save to app documents directory
  - Generate unique filename (timestamp + UUID)
  - Return file path

###### Subtask 2.2.1.2: Create capture service wrapper
- **File**: `lib/ui/camera/widgets/capture_service.dart`
- **Responsibilities**:
  - Handle capture process
  - Show capture animation
  - Save photo metadata to database
  - Handle capture errors

###### Subtask 2.2.1.3: Add capture button widget
- **File**: `lib/ui/camera/widgets/capture_button.dart`
- **Design**:
  - Large circular button
  - Animated on press
  - Disabled during capture
  - Shows progress indicator during capture

---

##### Task 2.2.2: Implement photo storage
**Subtasks**:

###### Subtask 2.2.2.1: Create file storage utility
- **File**: `lib/utils/file_storage.dart`
- **Methods**:
  - `Future<Directory> getPhotosDirectory()`
  - `Future<String> generatePhotoFilename()`
  - `Future<File> savePhoto(String sourcePath)`
  - `Future<void> deletePhoto(String path)`

###### Subtask 2.2.2.2: Integrate with database
- **Description**: Save photo metadata after capture
- **Process**:
  1. Capture photo
  2. Get file info (size, dimensions)
  3. Create Photo entity
  4. Insert into database via GalleryAdapter
  5. Notify UI of new photo

---

#### Feature 2.3: Camera Toggling (Front/Back)
**New Feature** - Create as sub-issue of #10

##### Task 2.3.1: Implement camera switching
**Subtasks**:

###### Subtask 2.3.1.1: Add toggle camera logic
- **File**: Update `lib/adapters/camera/camera_adapter.dart`
- **Method**: `Future<void> toggleCamera()`
- **Process**:
  1. Dispose current controller
  2. Get next camera (front -> back -> front)
  3. Initialize new controller
  4. Update state

###### Subtask 2.3.1.2: Create toggle camera button
- **File**: `lib/ui/camera/widgets/toggle_camera_button.dart`
- **Icon**: Rotating camera icon
- **Position**: Top right of screen
- **Behavior**: Disable during toggle animation

---

#### Feature 2.4: Zoom Control
**New Feature** - Create as sub-issue of #10

##### Task 2.4.1: Implement zoom functionality
**Subtasks**:

###### Subtask 2.4.1.1: Add zoom to camera API
- **Methods to add**:
  ```dart
  Future<void> setZoomLevel(double zoom);
  double get minZoomLevel;
  double get maxZoomLevel;
  double get currentZoomLevel;
  ```

###### Subtask 2.4.1.2: Add zoom notifier to adapter
- **File**: Update `lib/adapters/camera/camera_adapter.dart`
- **Add**: `late final ValueNotifier<double> zoomLevelNotifier;`

###### Subtask 2.4.1.3: Create zoom slider widget
- **File**: `lib/ui/camera/widgets/zoom_slider.dart`
- **UI**: Vertical slider on side of screen
- **Range**: minZoom to maxZoom
- **Update**: Call adapter.setZoomLevel on change

###### Subtask 2.4.1.4: Add pinch-to-zoom gesture
- **File**: Update `lib/ui/camera/widgets/camera_preview_widget.dart`
- **Add**: GestureDetector with onScaleUpdate
- **Calculate zoom from scale**: `newZoom = currentZoom * scale`

---

#### Feature 2.5: Flash & Torch
**New Feature** - Create as sub-issue of #10

##### Task 2.5.1: Implement flash modes
**Subtasks**:

###### Subtask 2.5.1.1: Add flash API
- **Enum**:
  ```dart
  enum FlashMode { off, auto, on, torch }
  ```
- **Methods**:
  ```dart
  Future<void> setFlashMode(FlashMode mode);
  FlashMode get currentFlashMode;
  ```

###### Subtask 2.5.1.2: Add flash control to adapter
- **File**: Update `lib/adapters/camera/camera_adapter.dart`
- **Add**: `late final ValueNotifier<FlashMode> flashModeNotifier;`

###### Subtask 2.5.1.3: Create flash button widget
- **File**: `lib/ui/camera/widgets/flash_button.dart`
- **UI**: Cycle through modes on tap
- **Icons**: Different icon for each mode
- **Position**: Top left of camera screen

---

### Epic 3: Basic Gallery & Asset Management
**Status**: Issue #11 exists - ADD FEATURE TASKS

**Description**: Implement foundational gallery/backend features

**Features to add as separate tasks/sub-issues:**

---

#### Feature 3.1: Media Indexing (device scan)
**New Feature** - Create as sub-issue of #11

##### Task 3.1.1: Implement device photo scanning
**Subtasks**:

###### Subtask 3.1.1.1: Add photo_manager plugin
- **Action**: Add `photo_manager` to pubspec.yaml
- **Purpose**: Access device photo library

###### Subtask 3.1.1.2: Create photo indexer service
- **File**: `lib/ui/gallery/widgets/photo_indexer_service.dart`
- **Methods**:
  ```dart
  Future<void> indexAllPhotos();
  Future<void> indexRecentPhotos({int days = 7});
  Stream<double> get indexingProgress;
  ```

###### Subtask 3.1.1.3: Add indexing to gallery adapter
- **File**: Update `lib/adapters/gallery/gallery_adapter.dart`
- **Add**: Progress tracking and cancellation support

###### Subtask 3.1.1.4: Create indexing progress UI
- **File**: `lib/ui/gallery/widgets/indexing_progress_dialog.dart`
- **UI**: Show progress bar and cancel button

---

#### Feature 3.2: Photo Grid (infinite scroll, caching)
**New Feature** - Create as sub-issue of #11

##### Task 3.2.1: Implement photo grid view
**Subtasks**:

###### Subtask 3.2.1.1: Create gallery screen
- **File**: `lib/ui/gallery/gallery_screen.dart`
- **Layout**:
  - Tab bar (Photos / Albums / Favorites)
  - Photo grid
  - FAB for camera
  - Selection mode toggle

###### Subtask 3.2.1.2: Create photo grid widget
- **File**: `lib/ui/gallery/widgets/photo_grid.dart`
- **Implementation**:
  - GridView.builder with lazy loading
  - 3-4 columns depending on screen size
  - Thumbnail loading with caching
  - Pull to refresh

###### Subtask 3.2.1.3: Implement infinite scroll
- **Description**: Load more photos as user scrolls
- **Implementation**:
  - Detect scroll position
  - Load next page when near bottom
  - Show loading indicator at bottom

###### Subtask 3.2.1.4: Add thumbnail caching
- **Plugin**: Use `cached_network_image` or implement custom cache
- **File**: `lib/utils/thumbnail_cache.dart`
- **Strategy**:
  - Generate thumbnails on demand
  - Cache in memory and disk
  - LRU eviction policy

---

#### Feature 3.3: Full-Screen Viewer (pan/zoom)
**New Feature** - Create as sub-issue of #11

##### Task 3.3.1: Implement photo viewer
**Subtasks**:

###### Subtask 3.3.1.1: Create photo viewer screen
- **File**: `lib/ui/gallery/photo_viewer_screen.dart`
- **Layout**:
  - Full-screen photo
  - Swipe to navigate between photos
  - Pinch to zoom
  - Tap to show/hide controls

###### Subtask 3.3.1.2: Add interactive photo widget
- **File**: `lib/ui/gallery/widgets/interactive_photo.dart`
- **Features**:
  - InteractiveViewer for pan/zoom
  - Double-tap to zoom
  - Reset zoom on swipe

###### Subtask 3.3.1.3: Add photo viewer controls
- **File**: `lib/ui/gallery/widgets/photo_viewer_controls.dart`
- **Controls**:
  - Back button
  - Share button
  - Delete button
  - Favorite button
  - Info button (show EXIF data)

---

## Phase 2: Professional Photography Tools
**Status**: Issue #2 exists
**Goal**: Implement "Pro" features that distinguish Camaroo

---

### Epic 4: Manual Camera Controls (The Core USP)
**New Epic** - Create as sub-issue of #2

**Description**: Allow photographers to manually control camera parameters

---

#### Feature 4.1: Exposure Engine
**New Feature** - Create as sub-issue of Epic 4

##### Task 4.1.1: Implement manual exposure control
**Subtasks**:

###### Subtask 4.1.1.1: Add exposure API
- **Methods**:
  ```dart
  Future<void> setExposureMode(ExposureMode mode);  // auto, manual
  Future<void> setExposureCompensation(double ev);  // -3.0 to +3.0
  Future<void> setISO(int iso);  // 100-3200
  Future<void> setShutterSpeed(Duration speed);  // 1/8000s to 1/30s
  ```

###### Subtask 4.1.1.2: Create exposure controls UI
- **File**: `lib/ui/camera/widgets/exposure_controls.dart`
- **UI**:
  - EV slider
  - ISO selector (dropdown or dial)
  - Shutter speed selector
  - Auto/Manual toggle

---

#### Feature 4.2: Manual Focus
**New Feature** - Create as sub-issue of Epic 4

##### Task 4.2.1: Implement focus control
**Subtasks**:

###### Subtask 4.2.1.1: Add focus API
- **Methods**:
  ```dart
  Future<void> setFocusMode(FocusMode mode);  // auto, manual, continuous
  Future<void> setFocusDistance(double distance);  // 0.0 to 1.0
  Future<void> setFocusPoint(Offset point);  // Tap to focus
  ```

###### Subtask 4.2.1.2: Create focus slider UI
- **File**: `lib/ui/camera/widgets/focus_slider.dart`
- **Position**: Side of screen
- **Visual**: Show focus distance value

###### Subtask 4.2.1.3: Add tap-to-focus
- **Implementation**: GestureDetector on preview
- **Visual**: Show focus indicator at tap point

---

#### Feature 4.3: White Balance
**New Feature** - Create as sub-issue of Epic 4

##### Task 4.3.1: Implement white balance control
**Subtasks**:

###### Subtask 4.3.1.1: Add white balance API
- **Methods**:
  ```dart
  Future<void> setWhiteBalanceMode(WhiteBalanceMode mode);  // auto, manual
  Future<void> setWhiteBalanceTemperature(int kelvin);  // 2000K-10000K
  ```

###### Subtask 4.3.1.2: Create white balance selector UI
- **File**: `lib/ui/camera/widgets/white_balance_selector.dart`
- **UI**: Slider with preset buttons (Daylight, Cloudy, Tungsten, etc.)

---

### Epic 5: Heads-Up Display (HUD)
**New Epic** - Create as sub-issue of #2

**Description**: Real-time visual feedback for photographers

---

#### Feature 5.1: Real-time Histogram
**New Feature** - Create as sub-issue of Epic 5

##### Task 5.1.1: Implement histogram
**Subtasks**:

###### Subtask 5.1.1.1: Add histogram calculation
- **File**: `lib/utils/histogram_calculator.dart`
- **Process**:
  - Sample preview frames
  - Calculate RGB histograms
  - Update at ~10fps

###### Subtask 5.1.1.2: Create histogram widget
- **File**: `lib/ui/camera/widgets/histogram_widget.dart`
- **UI**: Overlay with RGB channel graphs
- **Position**: Top or bottom of screen, semi-transparent

---

#### Feature 5.2: Grid & Level
**New Feature** - Create as sub-issue of Epic 5

##### Task 5.2.1: Implement grid overlay
**Subtasks**:

###### Subtask 5.2.1.1: Create grid overlay widget
- **File**: `lib/ui/camera/widgets/grid_overlay.dart`
- **Grids**:
  - Rule of thirds (2x2 grid)
  - Golden ratio
  - Diagonal
- **Toggle**: Settings or button

###### Subtask 5.2.1.2: Add level indicator
- **Plugin**: Use `sensors_plus` for gyroscope
- **Widget**: `lib/ui/camera/widgets/level_indicator.dart`
- **UI**: Horizontal line showing tilt angle

---

## Summary

This comprehensive breakdown provides:

1. **Detailed subtasks** for all existing issues (#6, #7, #8, #9, #10, #11)
2. **New feature tasks** for Epic 2 (Camera features)
3. **New feature tasks** for Epic 3 (Gallery features)
4. **Complete structure** for Phase 2 features
5. **Code context** from the MVC architecture in dev branch
6. **File locations** following the established pattern
7. **Implementation notes** with code examples

All tasks follow the architectural pattern:
- Abstractions in `lib/core/abstractions/`
- Models in `lib/core/models/`
- Adapters in `lib/adapters/`
- UI in `lib/ui/`
- Plugin wrappers in `lib/ui/<feature>/widgets/`

Each task is actionable, testable, and includes specific file names and implementation guidance.
