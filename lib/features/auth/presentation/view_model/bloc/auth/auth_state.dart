
import 'package:shopping_app/features/auth/data/model/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class AuthRegistered extends AuthState { // New state for registration success
  AuthRegistered();
}
class AuthPasswordResetSuccess extends AuthState { // New state
  AuthPasswordResetSuccess();
}