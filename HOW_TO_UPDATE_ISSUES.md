# How to Update GitHub Issues

This guide explains how to update the GitHub issues in your repository based on the comprehensive documentation I've created.

## Important Note

I don't have direct access to create or update GitHub issues through the API (this requires write permissions). However, I've created two comprehensive documents that you can use as a reference:

1. **`PROJECT_ISSUES_DETAILED.md`** - Complete breakdown of all tasks and subtasks with code examples
2. **`ISSUE_UPDATES_SUMMARY.md`** - Concise guide showing exactly which issues to update and what to add

## How to Use This Documentation

### Option 1: Manual Updates (Recommended for Full Control)

1. Open the [Issues page](https://github.com/harisrovca/camaroo/issues) in your repository
2. For each issue listed in `ISSUE_UPDATES_SUMMARY.md`:
   - Click on the issue number to open it
   - Click "Edit" on the issue description
   - Add the subtasks as a checklist using Markdown:
     ```markdown
     ## Subtasks
     - [ ] Subtask 1: Description
     - [ ] Subtask 2: Description
     ```
   - Add any code context or architecture notes from the detailed documentation
   - Save the changes

### Option 2: Automated Script (For Bulk Updates)

If you have GitHub CLI (`gh`) installed, you can use a script like this:

```bash
#!/bin/bash

# Update Issue #12
gh issue edit 12 --body "$(cat << 'EOF'
Setup and structure Flutter project

## Architecture Context
The project uses MVC with:
- **Adapters** (`lib/adapters/`): Controllers with business logic
- **Models** (`lib/core/models/`): Data implementations
- **Abstractions** (`lib/core/abstractions/`): Interfaces
- **UI** (`lib/ui/`): Views and screens

## Subtasks
- [ ] Subtask 1.1.1.1: Verify and document directory structure
- [ ] Subtask 1.1.1.2: Create feature-specific directory structure
- [ ] Subtask 1.1.1.3: Update root README with architecture documentation
- [ ] Subtask 1.1.1.4: Verify and document dependencies
- [ ] Subtask 1.1.1.5: Create project conventions document

## Acceptance Criteria
- All directories exist and are documented
- README explains MVC architecture
- CONTRIBUTING.md created
EOF
)"

# Repeat for other issues...
```

### Option 3: Use GitHub Web Interface with Templates

1. Open `ISSUE_UPDATES_SUMMARY.md`
2. Copy the updated issue description for an issue
3. Navigate to that issue on GitHub
4. Edit and paste the updated description
5. Repeat for all issues

## Creating New Sub-Issues

For new features (like Camera Preview, Photo Grid, etc.), you'll need to create new issues:

1. Go to [New Issue](https://github.com/harisrovca/camaroo/issues/new)
2. Use the title and description from `ISSUE_UPDATES_SUMMARY.md`
3. Add appropriate labels (e.g., "enhancement")
4. Link to the parent epic by mentioning it: "Part of #10"
5. Create the issue

## Quick Reference: Issues to Update

### Existing Issues (Add Subtasks)
- Issue #12: Setup and structure Flutter project → 5 subtasks
- Issue #13: Configure linting and formatting → 5 subtasks
- Issue #14: Implement CI/CD pipeline → 6 subtasks
- Issue #7: State Management Setup → 2 tasks, 8 subtasks
- Issue #8: Permission Manager → 4 tasks, 13 subtasks
- Issue #9: Local Database → 4 tasks, 13 subtasks
- Issue #10: Epic 2 (add feature list)
- Issue #11: Epic 3 (add feature list)
- Issue #2: Phase 2 (add epic list)

### New Issues to Create
- 5 features under Epic 2 (Issue #10)
- 3 features under Epic 3 (Issue #11)
- 2 epics with 5 features under Phase 2 (Issue #2)
- 1 documentation issue

Total: ~18 new issues to create

## What I've Provided

### PROJECT_ISSUES_DETAILED.md
This 1,800+ line document contains:
- Complete architecture overview with code examples
- Detailed breakdown of every task and subtask
- Specific file paths for each implementation
- Code snippets showing expected patterns
- Testing guidelines
- Dependencies needed
- Implementation notes

Use this as your **complete reference** when implementing features.

### ISSUE_UPDATES_SUMMARY.md
This concise document provides:
- Exact text to add to each existing issue
- Templates for new issues to create
- Quick checklist of what needs to be done
- Summary statistics

Use this as your **action guide** for updating GitHub issues.

## Recommended Workflow

1. **Start with existing issues** (#12, #13, #14, #7, #8, #9)
   - Add subtasks as checklists
   - Add architecture context
   - Update acceptance criteria

2. **Update epic issues** (#10, #11, #2)
   - Add feature lists
   - Link to sub-issues (once created)

3. **Create new feature issues**
   - Use templates from ISSUE_UPDATES_SUMMARY.md
   - Reference PROJECT_ISSUES_DETAILED.md for details
   - Link to parent epics

4. **Create documentation issue**
   - For architecture docs that need to be written

## Benefits of This Approach

✅ **Detailed**: Every subtask has specific implementation guidance
✅ **Consistent**: All tasks follow the established MVC architecture
✅ **Actionable**: Each subtask is small enough to implement independently
✅ **Tested**: Each major feature includes testing subtasks
✅ **Documented**: Code context provided for every task

## Need Help?

If you need assistance with:
- Updating a specific issue
- Creating an automation script
- Understanding the architecture context
- Implementing any specific feature

Please ask! I can:
- Provide more detailed code examples
- Explain the architecture decisions
- Help write implementation guides
- Create helper scripts

## Example: Updating Issue #12

Here's exactly what to do for Issue #12:

1. Go to https://github.com/harisrovca/camaroo/issues/12
2. Click "Edit"
3. Replace or append with this:

```markdown
## Current Issue Description
Setup and structure Flutter project

## Architecture Context
The project uses MVC with:
- **Adapters** (`lib/adapters/`): Controllers with business logic
- **Models** (`lib/core/models/`): Data implementations  
- **Abstractions** (`lib/core/abstractions/`): Interfaces
- **UI** (`lib/ui/`): Views and screens
- **Plugin Wrappers** (`lib/ui/<feature>/widgets/`): Platform code

Example from existing code:
```dart
// lib/adapters/home_adapter.dart - Controller
class HomeAdapter {
  HomeAdapter(HomeApi homeApi) {
    counterNotifier = ValueNotifier(homeApi.counter);
  }
  late final ValueNotifier<int> counterNotifier;
}
```

## Subtasks
- [ ] Verify and document directory structure
  - Ensure lib/adapters/, lib/core/models/, lib/core/abstractions/, lib/ui/ exist
  - Add .gitkeep files where needed
- [ ] Create feature-specific directory structure
  - Create lib/adapters/camera/, lib/adapters/gallery/, lib/adapters/permissions/
  - Create corresponding models and abstractions directories
  - Create lib/ui/camera/, lib/ui/gallery/ with widgets/ subdirectories
- [ ] Update root README with architecture documentation
  - Explain MVC pattern
  - Document directory structure with examples
  - Add state management approach (ValueNotifier)
- [ ] Verify and document dependencies
  - Document dependency management in README
  - Explain pub get workflow
- [ ] Create project conventions document (CONTRIBUTING.md)
  - Setup instructions
  - Code organization patterns
  - Naming conventions
  - Testing requirements

## Acceptance Criteria
- All directories exist and documented
- README explains MVC architecture with examples
- CONTRIBUTING.md guides developers
- Directory structure matches home example pattern
```

4. Save

Repeat this process for all other issues using the content from `ISSUE_UPDATES_SUMMARY.md`.
