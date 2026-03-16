import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String phoneNumber;
  final String password;
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final Map<String, dynamic>? data;

  const LoginState({
    this.phoneNumber = "",
    this.password = "",
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.data,
  });

  LoginState copyWith({
    String? phoneNumber,
    String? password,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    Map<String, dynamic>? data,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
    phoneNumber,
    password,
    isLoading,
    isSuccess,
    error,
    data,
  ];
}
