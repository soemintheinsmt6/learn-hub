import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/core/utils/app_color.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:learn_hub/shared/widgets/profile_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final UserRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(repository)..add(LoadProfile(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final user = state.user;
              if (user == null) {
                return const SizedBox();
              }

              return Scaffold(
                appBar: AppBar(title: const Text('Home')),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 20,
                        right: 20,
                      ),
                      child: ProfileCard(user: user),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
