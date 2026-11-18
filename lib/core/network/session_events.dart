import 'dart:async';

/// Lets the network layer tell the app "the session is over" (the refresh
/// token was rejected) without depending on any screen or Bloc.
class SessionEvents {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get expired => _controller.stream;

  void notifyExpired() {
    if (!_controller.isClosed) _controller.add(null);
  }
}