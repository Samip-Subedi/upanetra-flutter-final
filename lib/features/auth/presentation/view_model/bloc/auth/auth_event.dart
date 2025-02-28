import 'dart:io';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  RegisterEvent(this.email, this.password,this.name, {File? profileImage});
}
class ResetPasswordEvent extends AuthEvent { // New event
  final String token;
  final String password;
  final String passwordConfirm;

  ResetPasswordEvent(this.token, this.password, this.passwordConfirm);
}
class LogoutEvent extends AuthEvent {}