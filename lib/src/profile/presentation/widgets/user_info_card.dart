import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: context.width * .425,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: Colors.grey.shade300, ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withAlpha(75),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
