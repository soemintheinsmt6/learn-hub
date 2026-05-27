import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/core/utils/app_color.dart';
import 'package:learn_hub/features/auth/presentation/screens/login_screen.dart';
import 'package:learn_hub/features/onboarding/domain/entities/on_board.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_bloc.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_event.dart';
import 'package:learn_hub/features/onboarding/presentation/bloc/onboarding_bloc/onboard_state.dart';
import 'package:learn_hub/features/onboarding/presentation/widgets/on_board_tile.dart';
import 'package:learn_hub/shared/widgets/buttons/bar_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _pageController;
  final _items = OnBoard.list;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardBloc(_items.length),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocSelector<OnBoardBloc, OnBoardState, bool>(
              selector: (state) => state.isLast,
              builder: (context, isLast) {
                if (isLast) return const SizedBox.shrink();
                return _skip(
                  onPressed: () {
                    final lastIndex = _items.length - 1;
                    context.read<OnBoardBloc>().add(
                      OnBoardPageChanged(lastIndex),
                    );
                    _animateTo(lastIndex);
                  },
                );
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<OnBoardBloc, OnBoardState>(
            builder: (context, state) {
              final bloc = context.read<OnBoardBloc>();
              final width = MediaQuery.of(context).size.width - 60;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        height: width + 180,
                        // onBoarImage 1:1 + (title, description container Height 180)
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _items.length,
                          onPageChanged: (index) {
                            bloc.add(OnBoardPageChanged(index));
                          },
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return OnBoardTile(item: item);
                          },
                        ),
                      ),
                      _pageIndicator(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50,
                      bottom: 30,
                    ),
                    child: _actionButton(bloc, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _skip({Function()? onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: Colors.black,
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: const Text('Skip'),
    );
  }

  Widget _actionButton(OnBoardBloc bloc, OnBoardState state) {
    return BarButton(
      onTap: () {
        if (state.isLast) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          final nextPage = state.currentIndex + 1;
          bloc.add(OnBoardPageChanged(nextPage));
          _animateTo(nextPage);
        }
      },
      title: state.isLast ? 'Sign In' : 'Continue',
    );
  }

  Widget _pageIndicator() {
    return Center(
      child: SmoothPageIndicator(
        controller: _pageController,
        count: _items.length,
        effect: ExpandingDotsEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: AppColors.primary,
          dotColor: Colors.grey.shade300,
          expansionFactor: 2.2,
          spacing: 6,
        ),
      ),
    );
  }
}
