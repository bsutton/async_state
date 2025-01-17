# AsyncInitState

AsyncInitState Provides a simple way of doing Async initialisation for a StatefulWidget.

> The StatefulWidget doesn't allow you to easily do async
initialisation, resulting in the need for convulated methods to
initialise state.

AsyncState provides a reliable and simple method of overcoming this
problem.

There are two classes in the async_state package [AsyncState] and [AwaitAsyncInit].  

To use [AsysncInitState] You derive your StatefulWidget's state from [AsyncState] instead of [State].


You then use [AwaitAsyncInit] in your [builder] so the builder
isn't called until the async initialisation is complete.

A default [waitingBuilder] and [errorBuilder] are provided but you can roll your own.


# Sponsored by OnePub
Help support AwaitAsyncInit by supporting [OnePub](https://onepub.dev), the private dart repository.
OnePub allows you to privately share dart packages between your own projects or with colleagues.
Try it for free and publish your first private package in seconds.

https://onepub.dev

Publish a private package in six commands:
```bash
dart pub global activate onepub
onepub login
flutter create -t package mypackage
cd mypackage
onepub pub private
dart pub publish
```
You can now add your private package to any app
```bash
onepub pub add mypackage
```

# Example
The easist way to understand AsyncState is by an example.

```dart
import 'package:async_state/async_state.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SchedulPageState();
}

/// Derrive from AsyncState rather than Sate
class _SchedulPageState extends AsyncState<SchedulePage> {
  /// requires async initialisation
  late final System system;
  /// requires sync initialisation so it can be disposed.
  late final TextEditingController _nameController;

  /// Items that are to be disposed must go in [initState]
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  /// Items that need to be initialised asychronously 
  /// go here. Make certain to [await] them, use 
  /// a [completer] if necessary.
  @override
  Future<void> asyncInitState() async {
    system = await DaoSystem().get();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    /// Waits for [asyncInitState] to complete and then calls
    /// the builder.
    return AwaitAsyncInit(this, builder: (context) => Text(system.name));
  }
}

class System {
  System(this.name);
  String name;
}

class DaoSystem {
  Future<System> get() async {
    /// get the system record from the db.
    return System('example');
  }
}

```
[AwaitAsyncInit] state includes a [waitingBuilder] and an [errorBuilder] to allow you to customise the UI during these stages but provides default builders for both.

You will mostly want to derive you own version of AwaitAsyncInit with
your own custom builders so you don't have to specify the 
[waitingBuilder] and [errorBuilder] at every invocation site (if you don't like the default ones),

```dart
/// Create your on [AwaitAsyncInit] to customise the
/// error and waiting builders without having to
/// specify them at every call site.
class MyAwaitAsyncInit extends StatelessWidget {
  MyAwaitAsyncInit(this.state,
      {required this.builder, this.waitingBuilder, this.errorBuilder});
  final AsyncState state;
  final WidgetBuilder builder;

  /// Include the waiting and error builders if you
  /// might want to do further customisation at some
  /// call sites otherwise delete these fields.
  final WaitingBuilder? waitingBuilder;
  final ErrorBuilder? errorBuilder;

  Widget build(BuildContext context) => AwaitAsyncInit(state,
      waitingBuilder: (context) => Center(child: Text('waiting')),
      errorBuilder: (context, error) => Center(child: Text(error.toString())),
      builder: (context) => builder(context));
}
```