# AI Coding Rules - Flutter Projects

> This file is the **single source of truth** for Claude and GitHub Copilot and others.
> Read it fully before generating any code, file, or suggestion.

---

## AI WORKFLOW RULES (apply before and after every task)

> These rules govern **how** the AI must behave during any code generation or file modification session.

### Rule 1 - Always apply changes to the MAIN project `lib/` directory

- When generating or modifying code, **always write changes directly into the MAIN project's `lib/` directory**:
  `/Users/mostafasamy/StudioProjects/talentlink/lib/`
- **NEVER** write to the worktree path (`.claude/worktrees/*/lib/`) - the user cannot see those changes.
- If a file path is known, create or edit it at the correct location inside the main `lib/`.
- Never leave code only as a chat response - it must land in the actual source tree.
- After every edit, verify the file path starts with `/Users/mostafasamy/StudioProjects/talentlink/lib/`, not with a worktree path.

```text
[OK] /Users/mostafasamy/StudioProjects/talentlink/lib/src/...   <- correct target
[NO] /Users/mostafasamy/StudioProjects/talentlink/.claude/worktrees/*/lib/src/...  <- WRONG - user cannot see this
[NO] .claude/suggestions.dart           <- wrong - never put code here only
[NO] Only shown in chat response        <- wrong - must be written to disk
```

### Rule 2 - Track all `lib/` changes in Git

- Any changes made inside the `lib/` directory must be tracked in Git.
- Do not add these files to `.gitignore`.
- Ensure all relevant source code is committed properly.

---

## GENERAL RULES (apply to ALL projects)

### Architecture - Layer Folder Structure

```text
lib/
  src/
    bloc/           # All BLoCs and Cubits
    data/
      remote/       # DTOs, API datasources, Dio calls
      local/        # Drift tables, DAOs
      repositories/ # Repository implementations
    domain/
      entities/     # Pure Dart models - business logic
      repositories/ # Abstract interfaces
      use_cases/    # One class, one method
    presentation/
      screens/      # Full pages
      widgets/      # Reusable UI components
    core/           # DI (GetIt), network, constants, extensions
```

**Rule:** never mix layers. A widget never touches a DTO. A BLoC never imports a Drift table directly.

---

### What the AI must NEVER do

```dart
// NEVER hardcode user-facing strings
Text('Submit')

// Always use localization
Text(S.of(context).submit)

// NEVER use setState for business logic
setState(() => _items = result);

// Always emit from BLoC
emit(MySuccess(result));

// NEVER write big functions
Future<void> doEverything() { /* 80 lines */ }

// Split into small focused methods (max ~20 lines per method)

// NEVER write big classes
class GodManager { /* 500 lines, 20 responsibilities */ }

// One class = one responsibility

// NEVER write large or obvious comments
// This loop iterates over the list
for (final item in items) { ... }

// Only comment WHY, never WHAT

// NEVER add a new package for something already solved
// by an existing dep or 10 lines of Dart
dependencies:
  some_helper_for_one_function: ^1.0.0

// NEVER leave outdated/dead code
// ignore: deprecated_member_use  (old workaround)
someDeprecatedMethod();

// NEVER use raw TextStyle directly
style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)

// Always use AppTheme textTheme or getTextStyle
style: Theme.of(context).textTheme.bodySmall?.copyWith(color: myColor)
```

---

### Text Styles

> Before writing any UI text style, read:
> `lib/src/config/theme/app_theme.dart`

**Rule:** Never use raw `TextStyle(...)` - always derive from `AppTheme`.

#### Forbidden

```dart
// Never hardcode TextStyle
style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)

// Never set fontFamily manually
style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)
```

#### Required

```dart
// Inside a widget - use textTheme
style: Theme.of(context).textTheme.bodySmall?.copyWith(color: myColor)

// Without context - use static helper
style: AppTheme.getTextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: myColor,
)
```

#### TextTheme Mapping

| textTheme key | fontSize | fontWeight |
|---|---:|---|
| `titleLarge` | 18 | w700 |
| `bodyLarge` | 16 | w700 |
| `titleMedium` | 14 | medium |
| `labelLarge` | 14 | normal |
| `bodyMedium` | 13 | w700 |
| `bodySmall` | 13 | medium |
| `titleSmall` | 11 | regular |
| custom sizes | any | any |

For custom sizes not in the table above, always use `AppTheme.getTextStyle(...)`.

#### Additional Rules

- Drop `const` when using `Theme.of(context)` - it is a runtime value.
- Always pass `color` via `.copyWith()` - never hardcode it in the base style.
- Font family is handled automatically by `AppTheme` based on language - never set it manually.

---

### Models

#### Data Layer DTO - everything nullable (API is untrusted)

- At the end of every returned model, make an extension function that parses it to the domain layer.

#### Domain Entity - nullability follows business logic

```dart
class Property extends Equatable {
  const Property({
    required this.id,       // must exist - crash is correct if missing
    required this.title,
    this.price,             // optional in domain - depends on feature logic
    this.area,
  });

  final int id;
  final String title;
  final String? price;
  final String? area;

  Property copyWith({
    int? id,
    String? title,
    String? price,
    String? area,
  }) => Property(
    id: id ?? this.id,
    title: title ?? this.title,
    price: price ?? this.price,
    area: area ?? this.area,
  );

  @override
  List<Object?> get props => [id, title, price, area];
}
```

**copyWith rule:** every parameter copies from `this.SAME_FIELD` - never from a different field.

---

### BLoC Pattern

```dart
// Event
abstract class MyEvent extends Equatable {}

class LoadItems extends MyEvent {
  const LoadItems({this.filter});

  final MyFilter? filter;

  @override
  List<Object?> get props => [filter];
}

// State
abstract class MyState extends Equatable {}

class MyInitial extends MyState {
  @override
  List<Object?> get props => [];
}

class MyLoading extends MyState {
  @override
  List<Object?> get props => [];
}

class MySuccess extends MyState {
  const MySuccess(this.items);

  final List<MyEntity> items;

  @override
  List<Object?> get props => [items];
}

class MyFailure extends MyState {
  const MyFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// BLoC
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc(this._useCase) : super(MyInitial()) {
    on<LoadItems>(_onLoadItems);
  }

  final GetItemsUseCase _useCase;

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<MyState> emit,
  ) async {
    emit(MyLoading());
    final result = await _useCase(event.filter);
    if (result is DataSuccess) {
      emit(MySuccess(items));
    } else {
      emit(MyFailure(failure.message));
    }
  }
}
```

---

### Widgets

```dart
// RTL-safe spacing - always use DirectionalEdgeInsets
padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),

// never
padding: const EdgeInsets.only(left: 16, right: 16),

// const wherever possible
const SizedBox(height: 16),
const Icon(Icons.check),

// max ~1 screen per file, max ~50 lines per build method
// split large builds into private _buildXxx() methods or sub-widgets
```

#### One Widget Per File

**Rule:** Never put multiple widget classes in the same file. Every widget gets its own file.

```text
// NEVER - multiple widgets in one file
// profile_contacts_screen.dart
class ProfileContactsScreen { ... }
class _ContactCard { ... }
class _MainBadge { ... }
class _EmptyContactsView { ... }

// ALWAYS - one widget per file
presentation/screens/profile_contacts_screen.dart  -> ProfileContactsScreen
presentation/widgets/contact_card.dart             -> ContactCard
presentation/widgets/main_badge.dart               -> MainBadge
presentation/widgets/empty_contacts_view.dart      -> EmptyContactsView
```

---

### Routing

**Rule:** Always respect and use the existing route class. Never define inline routes or navigate using raw string paths.

- Read the project's route class before adding any navigation.
- Register new routes inside the existing route class only - never create a parallel routing mechanism.
- Use the route class constants/methods for all `Navigator` or `GoRouter` calls.

---

### Services - Check Before Creating

**Rule:** Before creating any new service, search the codebase for an existing one that covers the same responsibility.

```text
// Example: need to download/save an image?
// Search first: does an image download service already exist?
//    grep for: download, image, save, file, gallery
// Never duplicate: ImageDownloadService, SaveImageHelper, DownloadManager - pick the one that exists
```

- Search by keyword across `lib/src/core/` and `lib/src/data/` before writing a new service.
- If a service exists but lacks a method, extend it - do not create a new class.

---

### Localization

- **Every** user-facing string: `S.of(context).key`
- File: `lib/generated/l10n.dart`
- Languages: **Arabic (RTL) + English**
- Never pass `BuildContext` deep into BLoC/UseCase - resolve strings in the widget then pass them as parameters if needed.

---

### Packages - use these, suggest no alternatives

| Purpose | Package |
|---|---|
| State | `flutter_bloc` |
| DI | `get_it` + `injectable` |
| Network | `dio` + `pretty_dio_logger` |
| Local DB | `drift` |
| Testing | `flutter_test` + `mocktail` |
| Calendar | `table_calendar` |
| OTA | `shorebird_code_push` |
| Crash | `firebase_crashlytics` |

---

### Widget Tests

```dart
// Always use shared helpers - never inline MaterialApp
Widget buildApp({
  required Widget child,
  List<BlocDescriptor> blocs = const [],
  bool scrollable = false,
})

Widget buildAppSimple({required Widget child})

// Always tearDown notifiers
tearDown(() => myNotifier.dispose());

// Scope finders inside dialogs
find.descendant(
  of: find.byType(Dialog),
  matching: find.byType(ElevatedButton),
)

// Parameterized tests - use for loop inside group
group('all months', () {
  for (int year = 2021; year <= 2029; year++) {
    for (int month = 1; month <= 12; month++) {
      testWidgets('...', (tester) async { ... });
    }
  }
});
```

---

## QUICK CHECKLIST (AI self-check before outputting code)

Before generating any code, verify:

- [ ] Did I follow the **layer folder** structure?
- [ ] Did I use `S.of(context)` for every string?
- [ ] Are all DTO fields `nullable`? Are domain fields logic-based?
- [ ] Does every `copyWith` copy from `this.SAME_FIELD`?
- [ ] Does every model extend `Equatable` with correct `props`?
- [ ] Did I use `EdgeInsetsDirectional` (not `EdgeInsets.only(left/right)`)?
- [ ] Is every function <= ~20 lines?
- [ ] Did I add any unnecessary package?
- [ ] Are comments explaining WHY only (not WHAT)?
- [ ] Did I use `flutter_bloc` / `get_it` / `drift` / `dio` - no alternatives?
- [ ] Did I avoid raw `TextStyle` and use `textTheme` instead?
- [ ] Did I read `lib/src/config/theme/app_theme.dart` before writing any text style?
- [ ] Did I apply all changes directly to the `lib/` directory?
- [ ] Did I put each widget in its **own file** (no multiple widget classes per file)?
- [ ] Did I use the existing **route class** for any navigation - never raw strings or inline routes?
- [ ] Did I **search for an existing service** before creating a new one?
