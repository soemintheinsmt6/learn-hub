import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_bloc.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_event.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_state.dart';

void main() {
  group('OnBoardBloc', () {
    test('initial state has currentIndex 0 and given length', () {
      final bloc = OnBoardBloc(5);

      expect(bloc.state, const OnBoardState(currentIndex: 0, length: 5));
      expect(bloc.state.isLast, isFalse);
    });

    blocTest<OnBoardBloc, OnBoardState>(
      'emits state with updated index when OnBoardPageChanged is added',
      build: () => OnBoardBloc(5),
      act: (bloc) => bloc.add(OnBoardPageChanged(2)),
      expect: () => const [OnBoardState(currentIndex: 2, length: 5)],
    );

    blocTest<OnBoardBloc, OnBoardState>(
      'sets isLast true when currentIndex is last page',
      build: () => OnBoardBloc(5),
      act: (bloc) => bloc.add(OnBoardPageChanged(4)),
      expect: () => const [OnBoardState(currentIndex: 4, length: 5)],
      verify: (bloc) {
        expect(bloc.state.isLast, isTrue);
      },
    );
  });
}
