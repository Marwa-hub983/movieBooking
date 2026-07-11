import 'package:movieapp/shared/constants/assets/assets.dart';

class Profile {
  const Profile({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;
}

const List<Profile> kDefaultProfiles = [
  Profile(name: 'Emenalo', image: profileEmenalo),
  Profile(name: 'Onyeka', image: profileOnyeka),
  Profile(name: 'Thelma', image: profileThelma),
  Profile(name: 'Kids', image: profileKids),
  Profile(name: 'Add Profile', image: profileAdd),
];
