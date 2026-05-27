import 'package:flutter/material.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, this.onTap});

  final User user;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.w600);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'images/profile.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: textStyle),
                Text(user.company, style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
