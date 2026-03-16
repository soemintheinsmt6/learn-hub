import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {}
