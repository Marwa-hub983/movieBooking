import 'package:flutter/material.dart';
import 'package:movieapp/shared/utils/responsive.dart';

/// Single tab item for [AppBottomNav].
class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });

  final IconData icon;
  final String label;
  final int? badgeCount;
}

/// Reusable Netflix-style bottom navigation bar.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.comingSoonBadgeCount,
    this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int? comingSoonBadgeCount;
  final List<AppBottomNavItem>? items;

  List<AppBottomNavItem> get _items =>
      items ??
      [
        const AppBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
        const AppBottomNavItem(icon: Icons.search, label: 'Search'),
        AppBottomNavItem(
          icon: Icons.video_collection_outlined,
          label: 'Coming Soon',
          badgeCount: comingSoonBadgeCount,
        ),
        const AppBottomNavItem(
          icon: Icons.download,
          label: 'Downloads',
        ),
        const AppBottomNavItem(icon: Icons.menu, label: 'More'),
      ];

  @override
  Widget build(BuildContext context) {
    final navItems = _items;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              for (var i = 0; i < navItems.length; i++)
                Expanded(
                  child: _BottomNavTile(
                    item: navItems[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white54;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(item.icon, color: color, size: 22.r),
              if (item.badgeCount != null && item.badgeCount! > 0)
                Positioned(
                  right: -8.w,
                  top: -4.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    constraints: BoxConstraints(minWidth: 14.r),
                    child: Text(
                      '${item.badgeCount}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
