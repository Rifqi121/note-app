import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  LoggedIn(this.email, this.password);
}

class Registered extends AuthEvent {
  final String email;
  final String password;

  Registered(this.email, this.password);
}

class LoggedOut extends AuthEvent {}
