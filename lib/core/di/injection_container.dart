import 'package:get_it/get_it.dart';

/// The app's service locator. Features register their classes here,
/// which is the one place that decides which implementation is used
/// (for example Firebase now, the Laravel API later).
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Registrations are added feature by feature, starting with auth.
}