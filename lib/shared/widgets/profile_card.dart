import 'package:flutter/material.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/shared/widgets/tiles/skill_tile.dart';
import 'images/cached_image.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    const aboutMe =
        'Experienced Mobile developer skilled in Flutter, Swift and SwiftUI with a solid understanding of mobile app architecture, UI/UX design principles, and software development life cycle.';

    const skills = [
      'Flutter',
      'SwiftUI',
      'UI/UX',
      'Animation',
      'Clean Architecture',
      'CI/CD',
    ];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FBFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'About Me',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                aboutMe,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'My Skills',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const SkillWrapList(skills: skills),
            ],
          ),
        ),
        Positioned(
          top: 10,
          child: Stack(
            children: [
              ClipOval(
                child: CachedImage(
                  url: user.photo ?? '',
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
