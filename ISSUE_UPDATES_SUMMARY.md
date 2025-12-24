# Issue Updates Summary

This document summarizes all the GitHub issues that need to be created or updated based on the detailed project plan. Use this as a guide to update the GitHub repository's issue tracker.

## Issues to Update (Add Subtasks)

### Issue #12: Task: Setup and structure Flutter project
**Action**: Add the following subtasks as checklist items in the issue description

- [ ] Subtask 1.1.1.1: Verify and document directory structure
- [ ] Subtask 1.1.1.2: Create feature-specific directory structure
- [ ] Subtask 1.1.1.3: Update root README with architecture documentation
- [ ] Subtask 1.1.1.4: Verify and document dependencies
- [ ] Subtask 1.1.1.5: Create project conventions document (CONTRIBUTING.md)

**Update Issue Description to Include**:
```markdown
This task establishes the directory structure and documentation for the Camaroo project following the MVC architecture pattern.

## Architecture Context
The project uses MVC with:
- **Adapters** (`lib/adapters/`): Controllers with business logic
- **Models** (`lib/core/models/`): Data implementations
- **Abstractions** (`lib/core/abstractions/`): Interfaces
- **UI** (`lib/ui/`): Views and screens
- **Plugin Wrappers** (`lib/ui/<feature>/widgets/`): Platform-specific code

## Subtasks
[Add checklist from above]

## Acceptance Criteria
- All directories exist and are documented
- README explains MVC architecture with examples
- CONTRIBUTING.md guides developers on conventions
- Directory structure matches the pattern shown in home example
```

---

### Issue #13: Task: Configure linting, formatting, and code standards
**Action**: Add the following subtasks as checklist items

- [ ] Subtask 1.1.2.1: Review and enhance analysis_options.yaml
- [ ] Subtask 1.1.2.2: Add formatting configuration (.editorconfig)
- [ ] Subtask 1.1.2.3: Create formatting and linting scripts
- [ ] Subtask 1.1.2.4: Set up pre-commit hooks (optional)
- [ ] Subtask 1.1.2.5: Validate linting on existing code

**Update Issue Description to Include**:
```markdown
This task establishes code quality standards for consistent, maintainable code.

## Code Context
Current setup:
- `analysis_options.yaml` exists
- `flutter_lints: ^6.0.0` in dev_dependencies

## Subtasks
[Add checklist from above]

## Acceptance Criteria
- `dart analyze --fatal-infos` passes with no errors
- `dart format --set-exit-if-changed .` passes
- Comprehensive linting rules documented
- Developer workflow documented in CONTRIBUTING.md
```

---

### Issue #14: Task: Implement CI/CD pipeline
**Action**: Add the following subtasks as checklist items

- [ ] Subtask 1.1.3.1: Create GitHub Actions workflow file (.github/workflows/flutter.yml)
- [ ] Subtask 1.1.3.2: Add dependency caching
- [ ] Subtask 1.1.3.3: Add build validation steps
- [ ] Subtask 1.1.3.4: Configure status checks for PRs
- [ ] Subtask 1.1.3.5: Add CI badges to README
- [ ] Subtask 1.1.3.6: Document CI/CD troubleshooting

**Update Issue Description to Include**:
```markdown
This task sets up continuous integration to automate testing, linting, and building.

## Implementation Details
Workflow should run on:
- Push to main/dev branches
- All pull requests

Steps:
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Run dart format check
5. Run dart analyze
6. Run tests
7. Build APK/iOS

## Subtasks
[Add checklist from above]

## Acceptance Criteria
- CI runs automatically on PRs
- Status checks required for merge
- Build badge visible in README
- CI documentation in CONTRIBUTING.md
```

---

### Issue #7: Feature: State Management Setup (MVC controller logic)
**Action**: Add tasks as sub-issues or as detailed checklist

**New Tasks to Add**:

#### Task 1.2.1: Define state management architecture
- [ ] Subtask 1.2.1.1: Document ValueNotifier pattern (create docs/STATE_MANAGEMENT.md)
- [ ] Subtask 1.2.1.2: Define state classes structure (base adapter, app state)
- [ ] Subtask 1.2.1.3: Plan camera state machine (create docs/CAMERA_STATE_MACHINE.md)
- [ ] Subtask 1.2.1.4: Plan gallery state management
- [ ] Subtask 1.2.1.5: Create state management testing guide (docs/TESTING_STATE.md)

#### Task 1.2.2: Implement base state utilities
- [ ] Subtask 1.2.2.1: Create async state wrapper (lib/core/models/async_state.dart)
- [ ] Subtask 1.2.2.2: Create disposable mixin (lib/core/abstractions/disposable.dart)
- [ ] Subtask 1.2.2.3: Create combined notifier utilities (lib/utils/notifier_utils.dart)

**Update Issue Description to Include**:
```markdown
This feature establishes state management patterns following MVC architecture.

## Architecture Context
The project uses ValueNotifier for reactive state, as demonstrated in HomeAdapter:
```dart
class HomeAdapter {
  HomeAdapter(HomeApi homeApi) {
    counterNotifier = ValueNotifier(homeApi.counter);
    homeApi.onCounterChanged = (value) => counterNotifier.value = value;
  }
  late final ValueNotifier<int> counterNotifier;
}
```

## Tasks
[Add task breakdown above]

## Acceptance Criteria
- State management documentation complete
- Base utilities implemented and tested
- State machine diagrams created
- All adapters follow consistent patterns
```

---

### Issue #8: Feature: Permission Manager
**Action**: Add tasks as sub-issues or detailed checklist

**New Tasks to Add**:

#### Task 1.3.1: Design permission architecture
- [ ] Subtask 1.3.1.1: Create permission abstraction (lib/core/abstractions/permissions/permission_api.dart)
- [ ] Subtask 1.3.1.2: Create permission model (lib/core/models/permissions/permission_model.dart)
- [ ] Subtask 1.3.1.3: Create permission adapter (lib/adapters/permissions/permission_adapter.dart)

#### Task 1.3.2: Implement permission UI flows
- [ ] Subtask 1.3.2.1: Create permission request widget
- [ ] Subtask 1.3.2.2: Create permission gate widget
- [ ] Subtask 1.3.2.3: Add permission strings to constants

#### Task 1.3.3: Handle permission edge cases
- [ ] Subtask 1.3.3.1: Handle permanently denied permissions
- [ ] Subtask 1.3.3.2: Handle permission restoration on app resume
- [ ] Subtask 1.3.3.3: Add permission error handling

#### Task 1.3.4: Test permission flows
- [ ] Subtask 1.3.4.1: Unit test permission adapter
- [ ] Subtask 1.3.4.2: Widget test permission UI
- [ ] Subtask 1.3.4.3: Integration test permission flow

**Update Issue Description to Include**:
```markdown
This feature creates a unified permission manager following MVC pattern.

## Architecture Context
Structure:
- **Abstraction**: `lib/core/abstractions/permissions/permission_api.dart`
- **Model**: `lib/core/models/permissions/permission_model.dart` (wraps permission_handler plugin)
- **Adapter**: `lib/adapters/permissions/permission_adapter.dart`
- **UI**: `lib/ui/permissions/widgets/` for permission request widgets

Permissions needed:
- Camera
- Microphone
- Storage
- Location (optional)

## Tasks
[Add task breakdown above]

## Dependencies
- permission_handler plugin

## Acceptance Criteria
- All permissions can be requested and checked
- UI handles denied/permanently denied states
- Tests cover all permission flows
```

---

### Issue #9: Feature: Local Database (photo/album metadata)
**Action**: Add tasks as sub-issues or detailed checklist

**New Tasks to Add**:

#### Task 1.4.1: Design database schema
- [ ] Subtask 1.4.1.1: Define Photo entity (lib/core/models/gallery/photo.dart)
- [ ] Subtask 1.4.1.2: Define Album entity (lib/core/models/gallery/album.dart)
- [ ] Subtask 1.4.1.3: Create database schema SQL (lib/core/models/gallery/schema.dart)

#### Task 1.4.2: Implement database layer
- [ ] Subtask 1.4.2.1: Create database abstraction (lib/core/abstractions/gallery/database_api.dart)
- [ ] Subtask 1.4.2.2: Implement database with sqflite (lib/core/models/gallery/database_model.dart)
- [ ] Subtask 1.4.2.3: Add database migration system (lib/core/models/gallery/migrations.dart)
- [ ] Subtask 1.4.2.4: Add database service wrapper (lib/ui/gallery/widgets/database_service.dart)

#### Task 1.4.3: Implement gallery adapter with database
- [ ] Subtask 1.4.3.1: Create gallery adapter (lib/adapters/gallery/gallery_adapter.dart)
- [ ] Subtask 1.4.3.2: Add photo indexing logic
- [ ] Subtask 1.4.3.3: Add photo cleanup logic

#### Task 1.4.4: Test database layer
- [ ] Subtask 1.4.4.1: Unit test database model
- [ ] Subtask 1.4.4.2: Unit test gallery adapter
- [ ] Subtask 1.4.4.3: Integration test with real database

**Update Issue Description to Include**:
```markdown
This feature provides local storage for photo metadata and albums following MVC pattern.

## Architecture Context
Structure:
- **Abstraction**: `lib/core/abstractions/gallery/database_api.dart`
- **Model**: `lib/core/models/gallery/` (Photo, Album, DatabaseModel)
- **Adapter**: `lib/adapters/gallery/gallery_adapter.dart`
- **Service**: `lib/ui/gallery/widgets/database_service.dart` (plugin wrapper)

## Database Schema
Tables:
- **photos**: id, file_path, captured_at, dimensions, metadata, is_favorite, album_id
- **albums**: id, name, description, cover_photo_id, photo_count

Indexes:
- photos.captured_at (DESC)
- photos.album_id
- photos.is_favorite

## Tasks
[Add task breakdown above]

## Dependencies
- sqflite plugin
- path plugin

## Acceptance Criteria
- CRUD operations work for photos and albums
- Database migrations supported
- Gallery adapter exposes state via ValueNotifiers
- Tests cover all database operations
```

---

### Issue #10: Epic 2: The Viewfinder (Basic Camera)
**Action**: Add features as sub-issues

**New Features to Create as Sub-Issues**:

#### Feature 2.1: Camera Preview
**Create new issue linked to #10**
- Title: "Feature: Camera Preview with Lifecycle Management"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 2.1

#### Feature 2.2: Capture Engine (JPEG)
**Create new issue linked to #10**
- Title: "Feature: Photo Capture and Storage"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 2.2

#### Feature 2.3: Camera Toggling (Front/Back)
**Create new issue linked to #10**
- Title: "Feature: Toggle Between Front and Back Cameras"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 2.3

#### Feature 2.4: Zoom Control
**Create new issue linked to #10**
- Title: "Feature: Camera Zoom with Slider and Pinch Gestures"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 2.4

#### Feature 2.5: Flash & Torch
**Create new issue linked to #10**
- Title: "Feature: Flash Mode Control (Off/Auto/On/Torch)"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 2.5

**Update Epic Issue #10 Description**:
```markdown
This epic implements a high-performance, stable camera viewfinder with core features.

## Architecture Context
Structure:
- **Abstraction**: `lib/core/abstractions/camera/camera_api.dart`
- **Model**: `lib/core/models/camera/camera_model.dart` (wraps camera plugin)
- **Adapter**: `lib/adapters/camera/camera_adapter.dart`
- **UI**: `lib/ui/camera/` screens and widgets
- **Services**: `lib/ui/camera/widgets/` for plugin wrappers

State Management:
- CameraAdapter exposes ValueNotifiers for state, controller, errors
- UI uses ValueListenableBuilder for reactive updates
- State machine: uninitialized -> initializing -> ready -> capturing -> ready

## Features
- [ ] #[new] Camera Preview
- [ ] #[new] Capture Engine (JPEG)
- [ ] #[new] Camera Toggling
- [ ] #[new] Zoom Control
- [ ] #[new] Flash & Torch

## Dependencies
- camera plugin
- path_provider plugin

## Acceptance Criteria
- Camera preview displays smoothly
- Photos captured and saved successfully
- All camera features work on iOS and Android
- Proper lifecycle management (pause/resume)
- Error handling for all edge cases
```

---

### Issue #11: Epic 3: Basic Gallery & Asset Management
**Action**: Add features as sub-issues

**New Features to Create as Sub-Issues**:

#### Feature 3.1: Media Indexing (device scan)
**Create new issue linked to #11**
- Title: "Feature: Device Photo Scanning and Indexing"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 3.1

#### Feature 3.2: Photo Grid (infinite scroll, caching)
**Create new issue linked to #11**
- Title: "Feature: Photo Grid with Infinite Scroll and Caching"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 3.2

#### Feature 3.3: Full-Screen Viewer (pan/zoom)
**Create new issue linked to #11**
- Title: "Feature: Full-Screen Photo Viewer with Pan and Zoom"
- Labels: enhancement
- Detailed tasks in PROJECT_ISSUES_DETAILED.md section 3.3

**Update Epic Issue #11 Description**:
```markdown
This epic implements foundational gallery features with efficient DB sync and UI responsiveness.

## Architecture Context
Structure:
- **Abstraction**: `lib/core/abstractions/gallery/database_api.dart`
- **Model**: `lib/core/models/gallery/` (Photo, Album, DatabaseModel)
- **Adapter**: `lib/adapters/gallery/gallery_adapter.dart`
- **UI**: `lib/ui/gallery/` screens and widgets
- **Services**: `lib/ui/gallery/widgets/` for indexing and caching

State Management:
- GalleryAdapter exposes ValueNotifiers for photos, albums, selected items
- Async state wrapper for loading/error/success states
- Pagination support for infinite scroll

## Features
- [ ] #[new] Media Indexing (device scan)
- [ ] #[new] Photo Grid (infinite scroll, caching)
- [ ] #[new] Full-Screen Viewer (pan/zoom)

## Dependencies
- photo_manager plugin (device photo access)
- cached_network_image or custom cache
- sqflite (database, already added in Feature 1.4)

## Acceptance Criteria
- Device photos indexed and stored in DB
- Photo grid displays efficiently with lazy loading
- Thumbnails cached for performance
- Full-screen viewer supports gestures
- Smooth scrolling with 1000+ photos
```

---

### Issue #2: Phase 2: Professional Photography Tools
**Action**: Add epics and features as sub-issues

**New Epics to Create as Sub-Issues**:

#### Epic 4: Manual Camera Controls (The Core USP)
**Create new issue linked to #2**
- Title: "Epic 4: Manual Camera Controls"
- Labels: enhancement
- Description from PROJECT_ISSUES_DETAILED.md

**Features under Epic 4** (create as sub-issues of Epic 4):
1. Feature 4.1: Exposure Engine (manual ISO, shutter speed, EV compensation)
2. Feature 4.2: Manual Focus (focus slider, tap-to-focus)
3. Feature 4.3: White Balance (temperature control 2000K-10000K)

#### Epic 5: Heads-Up Display (HUD)
**Create new issue linked to #2**
- Title: "Epic 5: Heads-Up Display (HUD)"
- Labels: enhancement
- Description from PROJECT_ISSUES_DETAILED.md

**Features under Epic 5** (create as sub-issues of Epic 5):
1. Feature 5.1: Real-time Histogram (RGB luminance distribution)
2. Feature 5.2: Grid & Level (rule of thirds, gyroscope level indicator)

**Update Phase 2 Issue #2 Description**:
```markdown
This phase implements professional photography tools that distinguish Camaroo from stock camera apps.

## Goal
Give photographers manual control over camera parameters and real-time visual feedback.

## Epics
- [ ] #[new] Epic 4: Manual Camera Controls
  - [ ] Feature 4.1: Exposure Engine
  - [ ] Feature 4.2: Manual Focus
  - [ ] Feature 4.3: White Balance
- [ ] #[new] Epic 5: Heads-Up Display (HUD)
  - [ ] Feature 5.1: Real-time Histogram
  - [ ] Feature 5.2: Grid & Level

## Architecture Context
Builds on camera architecture from Phase 1:
- Camera API extended with manual control methods
- CameraAdapter exposes additional ValueNotifiers for manual controls
- UI adds professional control widgets to camera screen

## Dependencies
- sensors_plus plugin (for level indicator)
- Image processing for histogram

## Target Audience
Professional and enthusiast photographers who want DSLR-like control on mobile.
```

---

## New Issues to Create

### Documentation Issues

#### Issue: Create Architecture Documentation
- Title: "Documentation: Architecture and Development Guide"
- Labels: documentation
- Description:
  ```markdown
  Create comprehensive documentation for the project architecture and development workflows.
  
  ## Files to Create
  - [ ] `docs/STATE_MANAGEMENT.md` - State management patterns
  - [ ] `docs/CAMERA_STATE_MACHINE.md` - Camera state transitions
  - [ ] `docs/TESTING_STATE.md` - Testing guidelines
  - [ ] `docs/ARCHITECTURE.md` - Overall architecture overview
  - [ ] `CONTRIBUTING.md` - Contribution guidelines
  
  ## Content Guidelines
  - Include code examples from existing implementation
  - Explain MVC pattern used in the project
  - Document naming conventions
  - Show how to add new features
  
  ## Reference
  Use HomeAdapter/HomeApi/HomeApiModel as examples throughout documentation.
  ```

---

## Summary Statistics

**Issues to Update**: 8 (Issues #2, #7, #8, #9, #10, #11, #12, #13, #14)

**New Sub-Issues to Create**:
- Under Epic 2 (#10): 5 features
- Under Epic 3 (#11): 3 features
- Under Phase 2 (#2): 2 epics with 5 features total
- Documentation: 1 issue

**Total Subtasks Added**: 100+ detailed subtasks across all issues

**Files Specified for Creation**: 50+ specific file paths provided

---

## Implementation Notes

1. **Architecture Consistency**: All issues now reference the MVC pattern established in the dev branch
2. **Code Examples**: Most subtasks include code snippets showing expected implementation
3. **File Locations**: Every subtask specifies exact file paths following the established structure
4. **Testing**: Each major feature includes testing subtasks
5. **Dependencies**: All required plugins identified and documented
6. **Acceptance Criteria**: Each issue has clear completion criteria

See `PROJECT_ISSUES_DETAILED.md` for complete implementation details of every subtask.
