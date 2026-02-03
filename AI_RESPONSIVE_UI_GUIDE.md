# AI Responsive UI Guide (Codex + Claude)

Use this guide when translating Figma screens into Flutter UI. It is written for LLM agents.
For app-specific tokens (colors, spacing, typography), see `RESPONSIVE_UI_GUIDE.md`.

## Figma MCP Workflow
- Use `get_design_context` on the target frame, not the entire page.
- Identify top-level Auto Layout groups and map each one to a Flutter layout widget.
- Read constraints:
  - Stretch or left+right pinned -> `Expanded`/`Flexible` with padding.
  - Center -> `Align` or `Center`.
  - Fixed size -> `SizedBox` or fixed `width`/`height`.
- Do not copy absolute positions. Rebuild using padding, alignment, and layout rules.

## Default Widgets First
- Use `Scaffold` + `AppBar` for top bars.
- Map Figma nav actions to `AppBar.leading`, `AppBar.title`, and `AppBar.actions`.
- Use `ListTile` for rows with leading/title/trailing.
- Use `NavigationBar` or `BottomNavigationBar` for tabs.
- Use `Card`/`Container` only when defaults cannot match the layout.

## Responsive Layout Rules
- Keep `SafeArea` at the screen root.
- Put scrollable content inside `Expanded` (or fixed height) to avoid overflow.
- Use `Expanded`, `Flexible`, and `Spacer` to distribute space in `Row`/`Column`.
- Use `Wrap` for chips or action rows that must reflow on small screens.
- Constrain max width on tablets/desktop with `Align` + `ConstrainedBox`.
- Use `LayoutBuilder` to switch layouts at breakpoints.
- Text in rows should be wrapped with `Flexible` and use `maxLines` + `overflow`.
- Avoid fixed width/height for text badges (e.g., "Урок 4").
  - Use padding-driven chips and allow text to define width.
  - Prefer `ConstrainedBox` with a `minWidth`/`minHeight` over `SizedBox(width, height)` if you need a baseline size.
  - If a badge sits inside a row, wrap it in `Flexible` only when it must shrink; otherwise let it size naturally.
  - Always set `maxLines: 1` and `overflow: TextOverflow.ellipsis` for long labels.
  - Example pattern (responsive badge):
    ```dart
    Container(
      constraints: const BoxConstraints(minHeight: 32, minWidth: 56),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x264FC35E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Урок 100005',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    )
    ```

## Avoid Stack for Layout
- Do not use `Stack` for normal layout or spacing.
- Use `Stack` only for overlays: badges, floating buttons, background shapes.
- If a design looks layered, confirm it is truly an overlay before using `Stack`.

## Layout Patterns

App bar with leading/trailing:
```dart
Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {},
    ),
    title: const Text('Title'),
    actions: [
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ],
  ),
  body: const SizedBox.shrink(),
);
```

Pinned CTA below scroll:
```dart
SafeArea(
  child: Column(
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          children: const [
            // content
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('CTA'),
          ),
        ),
      ),
    ],
  ),
);
```

Responsive split layout:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isWide = constraints.maxWidth >= 700;
    if (isWide) {
      return Row(
        children: [
          Expanded(child: leftPane),
          const SizedBox(width: 24),
          Expanded(child: rightPane),
        ],
      );
    }
    return Column(
      children: [
        leftPane,
        const SizedBox(height: 24),
        rightPane,
      ],
    );
  },
);
```

List row with leading/trailing:
```dart
ListTile(
  leading: const Icon(Icons.school),
  title: const Text('Lesson title'),
  subtitle: const Text('Subtitle'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {},
);
```

## Figma to Flutter Mapping
- Auto Layout (vertical) -> `Column`
- Auto Layout (horizontal) -> `Row`
- Space between -> `MainAxisAlignment.spaceBetween`
- Hug contents -> intrinsic size, no `Expanded`
- Fill container -> `Expanded` or `SizedBox(width: double.infinity)`
- Fixed size -> `SizedBox`
- Corner radius -> `ClipRRect` or `BoxDecoration`
- Absolute layout -> only for true overlays

## Checklist Before Finishing
- `AppBar` used with leading/title/actions when there is a top bar.
- No `Stack` used for standard layout.
- Scrollable content is inside `Expanded`.
- Text in rows is wrapped with `Flexible` and uses overflow handling.
- Layout adapts to narrow and wide widths (`Wrap` or `LayoutBuilder`).
- Spacing/colors/typography align with `RESPONSIVE_UI_GUIDE.md`.
