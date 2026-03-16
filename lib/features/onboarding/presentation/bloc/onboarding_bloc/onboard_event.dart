abstract class OnBoardEvent {}

class OnBoardPageChanged extends OnBoardEvent {
  final int index;

  OnBoardPageChanged(this.index);
}

