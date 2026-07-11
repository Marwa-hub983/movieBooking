import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/shared/constants/assets/assets.dart';
import 'package:movieapp/shared/utils/responsive.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _profiles = [
    (name: 'Emenalo', image: profileEmenalo),
    (name: 'Onyeka', image: profileOnyeka),
    (name: 'Thelma', image: profileThelma),
    (name: 'Kids', image: profileKids),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: 12.h),
          _ProfilesRow(profiles: _profiles),
          SizedBox(height: 16.h),
          const _ManageProfiles(),
          SizedBox(height: 20.h),
          const _ShareNetflixCard(),
          SizedBox(height: 8.h),
          _MenuTile(
            icon: Icons.check,
            label: 'My List',
            onTap: () {},
          ),
          Divider(height: 1, thickness: 1, color: Colors.white12, indent: 16.w),
          _MenuTile(label: 'App Settings', onTap: () {}),
          _MenuTile(label: 'Account', onTap: () {}),
          _MenuTile(label: 'Help', onTap: () {}),
          _MenuTile(label: 'Sign Out', onTap: () {}),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _ProfilesRow extends StatelessWidget {
  const _ProfilesRow({required this.profiles});

  final List<({String name, String image})> profiles;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          for (final profile in profiles) ...[
            _ProfileAvatar(name: profile.name, image: profile.image),
            SizedBox(width: 12.w),
          ],
          const _AddProfileAvatar(),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.asset(
            image,
            width: 58.r,
            height: 58.r,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          name,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _AddProfileAvatar extends StatelessWidget {
  const _AddProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white54, width: 1.5),
          ),
          child: Icon(Icons.add, color: Colors.white, size: 28.r),
        ),
        SizedBox(height: 6.h),
        Text(
          'Add Profile',
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _ManageProfiles extends StatelessWidget {
  const _ManageProfiles();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, color: Colors.white70, size: 16.r),
          SizedBox(width: 8.w),
          Text(
            'Manage Profiles',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareNetflixCard extends StatelessWidget {
  const _ShareNetflixCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sms_outlined, color: Colors.white, size: 22.r),
              SizedBox(width: 10.w),
              Text(
                'Tell friends about Netflix.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sit quam dui, vivamus bibendum ut. A morbi mi tortor ut '
            'felis non accumsan accumsan quis. Massa,',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Terms & Conditions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white54,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.h,
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: 'https://www.netflix.com'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  child: Text(
                    'Copy Link',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SocialItem(
                child: Icon(Icons.chat, color: const Color(0xFF25D366), size: 28.r),
              ),
              _divider(),
              _SocialItem(
                child: Icon(Icons.facebook, color: const Color(0xFF1877F2), size: 28.r),
              ),
              _divider(),
              _SocialItem(
                child: Icon(Icons.mail_outline, color: Colors.white, size: 28.r),
              ),
              _divider(),
              _SocialItem(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.more_vert, color: Colors.white, size: 22.r),
                    Text(
                      'More',
                      style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36.h, color: Colors.white24);
  }
}

class _SocialItem extends StatelessWidget {
  const _SocialItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: child),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 22.r),
              SizedBox(width: 12.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
