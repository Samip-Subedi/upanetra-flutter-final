/// A generic abstract class for all use cases in the application.
///
/// [Params] represents the parameters required by the use case.
/// If no parameters are needed, use [NoParams].
abstract class UseCase<Type, Params> {
  /// Executes the use case and returns a [Future] of [Type].
  Future<Type> call(Params params);
}

/// A utility class to represent use cases that don't require parameters.
class NoParams {
  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}