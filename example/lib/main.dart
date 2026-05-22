import 'package:flutter/material.dart';
import 'package:keyboard_accessory/keyboard_accessory.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'keyboard_accessory demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const _RootPage(),
    );
  }
}

class _RootPage extends StatelessWidget {
  const _RootPage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('keyboard_accessory'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Navigation'),
              Tab(text: 'Custom actions'),
              Tab(text: 'Custom bar'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NavigationTab(),
            _CustomActionsTab(),
            _CustomBarTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 — default navigation bar (prev / next / done)
// ---------------------------------------------------------------------------

class _NavigationTab extends StatefulWidget {
  const _NavigationTab();

  @override
  State<_NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<_NavigationTab> {
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _bioFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAccessoryHost(
      focusNodes: [_nameFocus, _emailFocus, _bioFocus],
      onDone: () => _formKey.currentState?.save(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Default navigation bar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap any field. Use the up/down arrows to jump between fields '
                'or the checkmark to dismiss the keyboard.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _emailFocus,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _bioFocus,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: KeyboardAccessoryTheme.defaultHeight + 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2 — custom actions (keep glass bar, swap buttons)
// ---------------------------------------------------------------------------

class _CustomActionsTab extends StatefulWidget {
  const _CustomActionsTab();

  @override
  State<_CustomActionsTab> createState() => _CustomActionsTabState();
}

class _CustomActionsTabState extends State<_CustomActionsTab> {
  final _searchFocus = FocusNode();
  final _controller = TextEditingController();
  String _lastSearch = '';

  @override
  void dispose() {
    _searchFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAccessoryHost(
      focusNodes: [_searchFocus],
      actions: [
        KeyboardAccessoryAction(
          icon: Icons.clear_rounded,
          tooltip: 'Clear',
          onPressed: _controller.text.isNotEmpty
              ? () => setState(() => _controller.clear())
              : null,
        ),
        KeyboardAccessoryAction.spacer,
        KeyboardAccessoryAction(
          icon: Icons.search_rounded,
          tooltip: 'Search',
          onPressed: () {
            setState(() => _lastSearch = _controller.text);
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Custom actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'The glass bar style is preserved; only the buttons change. '
              'Clear (left) and Search (right) replace the default nav row.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            TextField(
              focusNode: _searchFocus,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (_lastSearch.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Last search: "$_lastSearch"'),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 3 — barBuilder (fully custom bar)
// ---------------------------------------------------------------------------

class _CustomBarTab extends StatefulWidget {
  const _CustomBarTab();

  @override
  State<_CustomBarTab> createState() => _CustomBarTabState();
}

class _CustomBarTabState extends State<_CustomBarTab> {
  final _firstFocus = FocusNode();
  final _lastFocus = FocusNode();

  @override
  void dispose() {
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAccessoryHost(
      focusNodes: [_firstFocus, _lastFocus],
      barBuilder: (ctx) {
        if (!ctx.isVisible) return const SizedBox.shrink();
        final kbBottom = MediaQuery.viewInsetsOf(context).bottom;
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          bottom: kbBottom,
          child: Material(
            elevation: 4,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded),
                      onPressed: ctx.hasPrevious ? ctx.onPrev : null,
                      tooltip: 'Previous',
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward_rounded),
                      onPressed: ctx.hasNext ? ctx.onNext : null,
                      tooltip: 'Next',
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: ctx.onDone,
                      child: const Text('Done'),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Custom bar via barBuilder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'barBuilder replaces the entire bar. You own the widget tree — '
              'position, colours, and layout are all yours. '
              'KeyboardAccessoryBarContext gives you focus state without '
              'needing your own listeners.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            TextField(
              focusNode: _firstFocus,
              decoration: const InputDecoration(
                labelText: 'First name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              focusNode: _lastFocus,
              decoration: const InputDecoration(
                labelText: 'Last name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
