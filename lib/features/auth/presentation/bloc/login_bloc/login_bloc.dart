import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(const LoginState()) {
    on<PhoneNumberChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber, error: null));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });

    on<LoginSubmitted>((event, emit) async {
      if (state.error != null) {
        emit(state.copyWith(error: null, isSuccess: false));
      }

      if (state.phoneNumber.isEmpty || state.password.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: 'Please enter username and password',
          ),
        );
        return;
      }

      if (state.password.length < 8) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: 'Password must be at least 8 characters',
          ),
        );
        return;
      }

      emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

      try {
        final result = await repository.login(
          state.phoneNumber,
          state.password,
        );

        emit(state.copyWith(isLoading: false, isSuccess: true, data: result));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: e.toString(),
          ),
        );
      }
    });
  }
}
