import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_event.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_state.dart';

class OnBoardBloc extends Bloc<OnBoardEvent, OnBoardState> {
  OnBoardBloc(int length) : super(OnBoardState(length: length)) {
    on<OnBoardPageChanged>(_onPageChanged);
  }

  void _onPageChanged(
    OnBoardPageChanged event,
    Emitter<OnBoardState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}

