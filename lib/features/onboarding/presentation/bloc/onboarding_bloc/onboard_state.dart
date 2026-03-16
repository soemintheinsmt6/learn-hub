import 'package:equatable/equatable.dart';

class OnBoardState extends Equatable {
  final int currentIndex;
  final int length;

  const OnBoardState({
    this.currentIndex = 0,
    required this.length,
  });

  bool get isLast => currentIndex == length - 1;

  OnBoardState copyWith({int? currentIndex, int? length}) {
    return OnBoardState(
      currentIndex: currentIndex ?? this.currentIndex,
      length: length ?? this.length,
    );
  }

  @override
  List<Object?> get props => [currentIndex, length];
}

