import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/core/utils/app_color.dart';

import 'package:learn_hub/shared/widgets/images/cached_image.dart';
import 'package:learn_hub/shared/widgets/info_row.dart';
import 'package:learn_hub/shared/widgets/tiles/skill_tile.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({
    super.key,
    required this.user,
    required this.repository,
  });

  final User user;
  final UserRepository repository;

  static const _aboutMeText =
      'Passionate UI/UX designer with over 5 years of experience in creating '
      'user-centered digital products. I love learning new technologies and '
      'sharing knowledge.';

  static const _skills = [
    'UI/UX',
    'Website Design',
    'Figma',
    'Animation',
    'User Persona',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(repository)..add(LoadProfile(user.id)),
      child: Scaffold(
        backgroundColor: AppColors.secondaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryBackground,
          centerTitle: true,
          title: Text('${user.name}\'s Details'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.settings),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.error != null && state.user == null) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final user = state.user ?? User.placeHolder;

              return _UserDetailsBody(user: user);
            },
          ),
        ),
      ),
    );
  }
}

class _UserDetailsBody extends StatelessWidget {
  const _UserDetailsBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: CachedImage(
                      url: user.photo ?? '',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ProfileStat(title: 'COURSES', value: '24'),
              _ProfileStat(title: 'COMPLETED', value: '12'),
              _ProfileStat(title: 'RATING', value: '4.8'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About Me',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            UserDetailsScreen._aboutMeText,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'My Skills',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SkillWrapList(skills: UserDetailsScreen._skills),
          const SizedBox(height: 24),
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: 'Company', value: user.company),
                const SizedBox(height: 12),
                InfoRow(label: 'Email', value: user.email),
                const SizedBox(height: 12),
                InfoRow(label: 'Phone', value: user.phone),
                const SizedBox(height: 12),
                InfoRow(label: 'Address', value: user.fullAddress),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
