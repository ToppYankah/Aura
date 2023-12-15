import 'package:aura/resources/app_images.dart';
import 'package:aura/ui/screens/edit_profile_screen.dart/models/avatar_data.dart';

class ProfileEditData {
  ProfileEditData._();

  static const List<AvatarData> avatars = [
    AvatarData(
      image: AppImages.maleAvatar1,
      url: "gs://aura-aq-d5c0a.appspot.com/male-1.png",
    ),
    AvatarData(
      image: AppImages.maleAvatar2,
      url: "gs://aura-aq-d5c0a.appspot.com/male-2.png",
    ),
    AvatarData(
      image: AppImages.maleAvatar3,
      url: "gs://aura-aq-d5c0a.appspot.com/male-3.png",
    ),
    AvatarData(
      image: AppImages.femaleAvatar1,
      url: "gs://aura-aq-d5c0a.appspot.com/female-1.png",
    ),
    AvatarData(
      image: AppImages.femaleAvatar2,
      url: "gs://aura-aq-d5c0a.appspot.com/female-2.png",
    ),
    AvatarData(
      image: AppImages.femaleAvatar3,
      url: "gs://aura-aq-d5c0a.appspot.com/female-3.png",
    ),
  ];
}
