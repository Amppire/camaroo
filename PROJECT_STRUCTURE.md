# Camaroo Project Structure - Visual Overview

This document provides a visual representation of the project plan, issues, and architecture.

## Project Hierarchy

```
Camaroo Camera App
│
├── Phase 1: Foundation & Core Capture (MVP) [Issue #4]
│   │
│   ├── Epic 1: Infrastructure & Architecture [Issue #5]
│   │   ├── Feature 1.1: Project Scaffold [Issue #6]
│   │   │   ├── Task 1.1.1: Setup and structure [Issue #12] ⚠️ NEEDS SUBTASKS
│   │   │   ├── Task 1.1.2: Configure linting [Issue #13] ⚠️ NEEDS SUBTASKS
│   │   │   └── Task 1.1.3: Implement CI/CD [Issue #14] ⚠️ NEEDS SUBTASKS
│   │   │
│   │   ├── Feature 1.2: State Management [Issue #7] ⚠️ NEEDS TASKS
│   │   │   ├── Task 1.2.1: Define architecture (8 subtasks)
│   │   │   └── Task 1.2.2: Implement utilities (3 subtasks)
│   │   │
│   │   ├── Feature 1.3: Permission Manager [Issue #8] ⚠️ NEEDS TASKS
│   │   │   ├── Task 1.3.1: Design architecture (3 subtasks)
│   │   │   ├── Task 1.3.2: Implement UI flows (3 subtasks)
│   │   │   ├── Task 1.3.3: Handle edge cases (3 subtasks)
│   │   │   └── Task 1.3.4: Test flows (3 subtasks)
│   │   │
│   │   └── Feature 1.4: Local Database [Issue #9] ⚠️ NEEDS TASKS
│   │       ├── Task 1.4.1: Design schema (3 subtasks)
│   │       ├── Task 1.4.2: Implement layer (4 subtasks)
│   │       ├── Task 1.4.3: Gallery adapter (3 subtasks)
│   │       └── Task 1.4.4: Test layer (3 subtasks)
│   │
│   ├── Epic 2: The Viewfinder [Issue #10] ⚠️ NEEDS FEATURES
│   │   ├── Feature 2.1: Camera Preview 🆕 NEEDS CREATION
│   │   │   ├── Task 2.1.1: Setup plugin (3 subtasks)
│   │   │   ├── Task 2.1.2: Abstraction layer (2 subtasks)
│   │   │   ├── Task 2.1.3: Camera adapter (1 subtask)
│   │   │   └── Task 2.1.4: Preview UI (3 subtasks)
│   │   │
│   │   ├── Feature 2.2: Capture Engine 🆕 NEEDS CREATION
│   │   │   ├── Task 2.2.1: Photo capture (3 subtasks)
│   │   │   └── Task 2.2.2: Storage (2 subtasks)
│   │   │
│   │   ├── Feature 2.3: Camera Toggling 🆕 NEEDS CREATION
│   │   │   └── Task 2.3.1: Implement switching (2 subtasks)
│   │   │
│   │   ├── Feature 2.4: Zoom Control 🆕 NEEDS CREATION
│   │   │   └── Task 2.4.1: Zoom functionality (4 subtasks)
│   │   │
│   │   └── Feature 2.5: Flash & Torch 🆕 NEEDS CREATION
│   │       └── Task 2.5.1: Flash modes (3 subtasks)
│   │
│   └── Epic 3: Gallery & Asset Management [Issue #11] ⚠️ NEEDS FEATURES
│       ├── Feature 3.1: Media Indexing 🆕 NEEDS CREATION
│       │   └── Task 3.1.1: Device scanning (4 subtasks)
│       │
│       ├── Feature 3.2: Photo Grid 🆕 NEEDS CREATION
│       │   └── Task 3.2.1: Grid view (4 subtasks)
│       │
│       └── Feature 3.3: Full-Screen Viewer 🆕 NEEDS CREATION
│           └── Task 3.3.1: Photo viewer (3 subtasks)
│
└── Phase 2: Professional Photography Tools [Issue #2] ⚠️ NEEDS EPICS
    │
    ├── Epic 4: Manual Camera Controls 🆕 NEEDS CREATION
    │   ├── Feature 4.1: Exposure Engine 🆕 NEEDS CREATION
    │   ├── Feature 4.2: Manual Focus 🆕 NEEDS CREATION
    │   └── Feature 4.3: White Balance 🆕 NEEDS CREATION
    │
    └── Epic 5: Heads-Up Display (HUD) 🆕 NEEDS CREATION
        ├── Feature 5.1: Real-time Histogram 🆕 NEEDS CREATION
        └── Feature 5.2: Grid & Level 🆕 NEEDS CREATION
```

Legend:
- ⚠️ NEEDS SUBTASKS: Existing issue that needs detailed subtasks added
- ⚠️ NEEDS TASKS: Existing issue that needs task breakdown added
- ⚠️ NEEDS FEATURES: Epic issue that needs feature sub-issues created
- 🆕 NEEDS CREATION: New issue that needs to be created

## File Structure (MVC Architecture)

```
lib/
│
├── main.dart                          # App entry point
│
├── adapters/                          # Controllers (Business Logic)
│   ├── home_adapter.dart              # ✅ Example exists
│   ├── camera/
│   │   └── camera_adapter.dart        # 🔜 To be created
│   ├── gallery/
│   │   └── gallery_adapter.dart       # 🔜 To be created
│   └── permissions/
│       └── permission_adapter.dart    # 🔜 To be created
│
├── core/
│   ├── abstractions/                  # Interfaces
│   │   ├── home_api.dart              # ✅ Example exists
│   │   ├── camera/
│   │   │   └── camera_api.dart        # 🔜 To be created
│   │   ├── gallery/
│   │   │   └── database_api.dart      # 🔜 To be created
│   │   ├── permissions/
│   │   │   └── permission_api.dart    # 🔜 To be created
│   │   └── disposable.dart            # 🔜 To be created
│   │
│   └── models/                        # Data Implementations
│       ├── home_model.dart            # ✅ Example exists
│       ├── async_state.dart           # 🔜 To be created
│       ├── camera/
│       │   └── camera_model.dart      # 🔜 To be created
│       ├── gallery/
│       │   ├── photo.dart             # 🔜 To be created
│       │   ├── album.dart             # 🔜 To be created
│       │   ├── schema.dart            # 🔜 To be created
│       │   ├── database_model.dart    # 🔜 To be created
│       │   └── migrations.dart        # 🔜 To be created
│       └── permissions/
│           └── permission_model.dart  # 🔜 To be created
│
├── ui/                                # Views (Presentation)
│   ├── home.dart                      # ✅ Example exists
│   ├── camera/
│   │   ├── camera_screen.dart         # 🔜 To be created
│   │   └── widgets/                   # Plugin wrappers & widgets
│   │       ├── camera_preview_widget.dart
│   │       ├── capture_button.dart
│   │       ├── toggle_camera_button.dart
│   │       ├── zoom_slider.dart
│   │       ├── flash_button.dart
│   │       └── capture_service.dart   # Plugin wrapper
│   │
│   ├── gallery/
│   │   ├── gallery_screen.dart        # 🔜 To be created
│   │   ├── photo_viewer_screen.dart   # 🔜 To be created
│   │   └── widgets/
│   │       ├── photo_grid.dart
│   │       ├── interactive_photo.dart
│   │       ├── database_service.dart  # Plugin wrapper
│   │       └── photo_indexer_service.dart
│   │
│   └── permissions/
│       └── widgets/
│           ├── permission_request_widget.dart
│           ├── permission_gate.dart
│           └── settings_dialog.dart
│
└── utils/                             # Utilities
    ├── app_constants.dart             # ✅ Exists
    ├── theme_constants.dart           # ✅ Exists
    ├── file_storage.dart              # 🔜 To be created
    ├── thumbnail_cache.dart           # 🔜 To be created
    ├── histogram_calculator.dart      # 🔜 To be created
    └── notifier_utils.dart            # 🔜 To be created
```

## Data Flow Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  (lib/ui/)                                                   │
│                                                              │
│  ┌──────────────┐                                           │
│  │ HomePage     │  Uses ValueListenableBuilder             │
│  │              │  to listen to state changes               │
│  └──────┬───────┘                                           │
│         │                                                    │
└─────────┼────────────────────────────────────────────────────┘
          │ Reads state via ValueNotifier
          │ Calls methods on adapter
          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Adapter Layer                             │
│  (lib/adapters/)                                             │
│                                                              │
│  ┌──────────────────────────────────────┐                  │
│  │ HomeAdapter                          │                  │
│  │                                      │                  │
│  │ • counterNotifier: ValueNotifier    │  Exposes state   │
│  │                                      │  Orchestrates    │
│  │ • Methods: incrementCounter()        │  between UI      │
│  │            resetCounter()            │  and Model       │
│  └───────────┬──────────────────────────┘                  │
│              │                                               │
└──────────────┼───────────────────────────────────────────────┘
               │ Calls methods on API
               │ Listens to callbacks
               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Model Layer                               │
│  (lib/core/)                                                 │
│                                                              │
│  ┌─────────────────────┐     ┌─────────────────────┐       │
│  │ HomeApi             │     │ HomeApiModel        │       │
│  │ (Interface)         │────▶│ (Implementation)    │       │
│  │                     │     │                     │       │
│  │ • counter: int      │     │ • _counter: int     │       │
│  │ • setCounter()      │     │ • setCounter()      │       │
│  │ • onCounterChanged  │     │ • onCounterChanged  │       │
│  └─────────────────────┘     └─────────────────────┘       │
│                                        │                     │
└────────────────────────────────────────┼─────────────────────┘
                                         │ Updates internal state
                                         │ Triggers callbacks
                                         ▼
                                   [Data Storage]
                           (In-memory, DB, or external API)
```

## State Management Pattern

```dart
// 1. Define Interface (Abstraction)
abstract class FeatureApi {
  FeatureState get state;
  void performAction();
  Function(FeatureState) onStateChanged = (state) {};
}

// 2. Implement Model
class FeatureModel implements FeatureApi {
  FeatureState _state = FeatureState.initial();
  
  @override
  FeatureState get state => _state;
  
  @override
  void performAction() {
    // Business logic
    _state = FeatureState.updated();
    onStateChanged(_state);
  }
  
  @override
  Function(FeatureState) onStateChanged = (state) {};
}

// 3. Create Adapter (Controller)
class FeatureAdapter {
  FeatureAdapter(FeatureApi api) {
    stateNotifier = ValueNotifier(api.state);
    api.onStateChanged = (state) => stateNotifier.value = state;
  }
  
  late final ValueNotifier<FeatureState> stateNotifier;
}

// 4. Use in UI
class FeatureScreen extends StatefulWidget {
  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  final api = FeatureModel();
  late final adapter = FeatureAdapter(api);
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: adapter.stateNotifier,
      builder: (context, state, child) {
        return Text(state.toString());
      },
    );
  }
}
```

## Task Distribution

### Total Counts
- **Existing Issues**: 12
- **Issues to Update**: 8
- **New Issues to Create**: ~18
- **Total Subtasks**: 100+
- **Total Files to Create**: 50+

### Breakdown by Epic

#### Epic 1: Infrastructure (Issues #5-9, #12-14)
- Features: 4
- Tasks: 13
- Subtasks: 50
- Status: Issues exist, need subtask details

#### Epic 2: Camera (Issue #10)
- Features: 5 (need creation)
- Tasks: 12
- Subtasks: 27
- Status: Epic exists, features need creation

#### Epic 3: Gallery (Issue #11)
- Features: 3 (need creation)
- Tasks: 3
- Subtasks: 11
- Status: Epic exists, features need creation

#### Phase 2: Professional Tools (Issue #2)
- Epics: 2 (need creation)
- Features: 5 (need creation)
- Tasks: TBD
- Subtasks: TBD
- Status: Phase exists, epics need creation

## Dependencies by Feature

```
Feature 1.1 (Project Scaffold)
├── flutter SDK (existing)
└── flutter_lints (existing)

Feature 1.2 (State Management)
└── (no external dependencies)

Feature 1.3 (Permission Manager)
└── permission_handler ⚠️ NEEDS ADDITION

Feature 1.4 (Local Database)
├── sqflite ⚠️ NEEDS ADDITION
└── path ⚠️ NEEDS ADDITION

Feature 2.1-2.5 (Camera Features)
├── camera ⚠️ NEEDS ADDITION
└── path_provider ⚠️ NEEDS ADDITION

Feature 3.1-3.3 (Gallery Features)
├── photo_manager ⚠️ NEEDS ADDITION
└── cached_network_image ⚠️ NEEDS ADDITION (or custom)

Feature 5.2 (Grid & Level)
└── sensors_plus ⚠️ NEEDS ADDITION
```

## Progress Tracking

### Phase 1 Completion
```
Infrastructure & Architecture:      [▓░░░░░░░░░] 10%
├── Project Scaffold:               [▓▓▓▓▓░░░░░] 50% (structure exists, needs docs)
├── State Management:               [░░░░░░░░░░]  0% (needs implementation)
├── Permission Manager:             [░░░░░░░░░░]  0% (needs implementation)
└── Local Database:                 [░░░░░░░░░░]  0% (needs implementation)

The Viewfinder (Camera):            [░░░░░░░░░░]  0%
├── Camera Preview:                 [░░░░░░░░░░]  0%
├── Capture Engine:                 [░░░░░░░░░░]  0%
├── Camera Toggling:                [░░░░░░░░░░]  0%
├── Zoom Control:                   [░░░░░░░░░░]  0%
└── Flash & Torch:                  [░░░░░░░░░░]  0%

Gallery & Asset Management:         [░░░░░░░░░░]  0%
├── Media Indexing:                 [░░░░░░░░░░]  0%
├── Photo Grid:                     [░░░░░░░░░░]  0%
└── Full-Screen Viewer:             [░░░░░░░░░░]  0%

Overall Phase 1:                    [▓░░░░░░░░░]  3%
```

### Phase 2 (Future)
```
Manual Camera Controls:             [░░░░░░░░░░]  0%
Heads-Up Display (HUD):            [░░░░░░░░░░]  0%

Overall Phase 2:                    [░░░░░░░░░░]  0%
```

## Next Steps

1. ✅ Architecture established (HomeAdapter example)
2. ✅ Project plan documented comprehensively
3. ⏳ Update existing issues with subtasks (use ISSUE_UPDATES_SUMMARY.md)
4. ⏳ Create new feature issues (use templates provided)
5. ⏳ Begin implementation (start with Issue #12)

## References

- **PROJECT_ISSUES_DETAILED.md** - Complete implementation guide
- **ISSUE_UPDATES_SUMMARY.md** - Issue update instructions
- **HOW_TO_UPDATE_ISSUES.md** - Step-by-step guide
- **This file** - Visual overview

---

*This project structure follows clean architecture principles with MVC pattern, ensuring separation of concerns, testability, and maintainability.*
