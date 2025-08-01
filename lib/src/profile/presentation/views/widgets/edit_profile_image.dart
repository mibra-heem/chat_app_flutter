import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/resources/media_res.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({required this.user, super.key});

  final LocalUser user;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (_, provider, __) {
        final image =
            user.avatar == null || user.avatar!.isEmpty ? null : user.avatar;
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            image: DecorationImage(
              fit: BoxFit.contain,
              image:
                  provider.pickedImage != null
                      ? FileImage(provider.pickedImage!)
                      : image != null
                      ? NetworkImage(image)
                      : const AssetImage(MediaRes.cartoonTeenageBoyCharacter)
                          as ImageProvider,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(128),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: provider.pickImage,
                  icon: const Icon(IconlyBold.edit, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
