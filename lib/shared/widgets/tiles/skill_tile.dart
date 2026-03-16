import 'package:flutter/material.dart';

class SkillTile extends StatelessWidget {
  const SkillTile({super.key, required this.skill});

  final String skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        skill,
        style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
      ),
    );
  }
}

class SkillWrapList extends StatelessWidget {
  const SkillWrapList({super.key, required this.skills});

  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) => SkillTile(skill: skill)).toList(),
    );
  }
}
