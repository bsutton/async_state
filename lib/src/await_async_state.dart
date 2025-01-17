import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import 'async_state.dart';

/// Use [AwaitAsyncInit] in your builder to wait for the [AsyncState]
/// to complete initialisation.
/// ```dart
/// Widget build(BuildContext context)
/// {
///   return AwaitAsyncInit(this, builder: (context) =>  ....)
/// }
/// ```
class AwaitAsyncInit extends StatelessWidget {
  const AwaitAsyncInit(this.state,
      {required this.builder,
      this.waitingBuilder,
      this.errorBuilder,
      super.key});

  final AsyncState state;
  final WaitingBuilder? waitingBuilder;
  final ErrorBuilder? errorBuilder;
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) => FutureBuilderEx(
      future: state.initialised,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
      builder: (context, _) => builder(context));
}
