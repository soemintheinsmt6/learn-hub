import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc(this.repository) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await repository.fetchUserById(event.id);

      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

