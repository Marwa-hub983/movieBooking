import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/shared/constants/assets/assets.dart';
import 'package:movieapp/shared/routes/routes.dart';
import 'package:movieapp/shared/utils/responsive.dart';
import 'package:movieapp/features/username/domain/models/profile.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({super.key, this.profiles = kDefaultProfiles});

  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            const _WhoIsWatchingHeader(),
            Expanded(
              child: Center(child: _ProfileGrid(profiles: profiles)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhoIsWatchingHeader extends StatelessWidget {
  const _WhoIsWatchingHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 32.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(netflix, height: 22.h, fit: BoxFit.contain),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  editIcon,
                  height: 18.r,
                  width: 18.r,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileGrid extends StatelessWidget {
  const _ProfileGrid({required this.profiles});

  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 28.w,
          mainAxisSpacing: 28.h,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return _ProfileTile(
            profile: profile,
            onTap: () {
              if (profile.name == 'Add Profile') return;
              context.go(routeHomeScreen, extra: profile);
            },
          );
        },
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile, this.onTap});

  final Profile profile;
  final VoidCallback? onTap;

  bool get _isAddProfile => profile.name == 'Add Profile';

  @override
  Widget build(BuildContext context) {
    final size = 100.r;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isAddProfile)
            SizedBox(
              width: size,
              height: size,
              child: Center(
                child: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 36.r, color: Colors.black),
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.asset(
                profile.image,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 8.h),
          Text(
            profile.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
