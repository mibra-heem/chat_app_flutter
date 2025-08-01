import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/resources/media_res.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {

    final name = context.select<UserProvider, String>(
      (provider) => provider.user?.name ?? '',
    );
    final image = context.select<UserProvider, String?>(
      (provider) {
        final user = provider.user;
        return user?.avatar == null || user!.avatar!.isEmpty ? null : user.avatar;
      },
    );
    final bio = context.select<UserProvider, String?>(
      (provider) => provider.user?.bio,
    );

    debugPrint('Building whole ProfileHeader() ....');
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              image != null
                  ? NetworkImage(image)
                  : const AssetImage(MediaRes.cartoonTeenageBoyCharacter)
                      as ImageProvider,
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
          debugPrint('Building Name Section ....');

            return Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            );
          },
        ),
        if (bio != null && bio.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * .15),
            child: Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }
}
