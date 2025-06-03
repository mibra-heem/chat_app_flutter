import 'package:flutter/material.dart';
import 'package:mustye/core/resources/media_res.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
              image != null
                  ? NetworkImage(image!)
                  : const AssetImage(MediaRes.youngManWorkingOnDesk)
                      as ImageProvider,
        ),
      ),
    );
  }
}
