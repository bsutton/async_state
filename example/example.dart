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
