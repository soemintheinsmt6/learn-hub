import 'package:equatable/equatable.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';

class UserState extends Equatable {
  final bool isLoading;
  final List<User> users;
  final String? error;

  const UserState({this.isLoading = false, this.users = const [], this.error});

  UserState copyWith({bool? isLoading, List<User>? users, String? error}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, users, error];
}
