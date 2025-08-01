import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    required this.title,
    required this.subtitle,
    this.image,
    this.trailing,
    this.onTap,
    this.withSubtitle = true,
    super.key,
  });

  const ContactTile.noSubtitle({
    required this.title,
    this.image,
    this.trailing,
    this.onTap,
    this.withSubtitle = false,
    super.key,
  }) : subtitle = '';

  final String title;
  final String? subtitle;
  final String? trailing;
  final String? image;
  final VoidCallback? onTap;
  final bool withSubtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: context.text.bodyMedium?.copyWith(
          fontSize: 15,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle:
          withSubtitle
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle!,
                    style: context.text.labelSmall?.copyWith(fontSize: 12),
                  ),
                ],
              )
              : null,
      trailing: Text(trailing ?? ''),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: image != null ? NetworkImage(image!) : null,
        child: image == null ? const Icon(Icons.person) : null,
      ),
    );
  }
}
