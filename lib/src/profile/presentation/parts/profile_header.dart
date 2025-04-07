import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/media_res.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image =
            user?.image == null || user!.image!.isEmpty ? null : user.image;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: image != null
                  ? NetworkImage(image)
                  : const AssetImage(
                      MediaRes.cartoonTeenageBoyCharacter,
                    ) as ImageProvider,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user!.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * .15),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
