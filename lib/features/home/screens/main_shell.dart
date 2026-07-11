import 'package:flutter/material.dart';
import 'package:movieapp/features/coming_soon/screens/coming_soon_screen.dart';
import 'package:movieapp/features/download/screens/downloads_screen.dart';
import 'package:movieapp/features/home/screens/home_screen.dart';
import 'package:movieapp/features/more/screens/more_screen.dart';
import 'package:movieapp/features/search/screens/search_screen.dart';
import 'package:movieapp/shared/widgets/app_bottom_nav.dart';

/// Hosts main tabs and keeps [AppBottomNav] visible while switching screens.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.profileName = 'User',
    this.profileImage,
    this.initialIndex = 0,
  });

  final String profileName;
  final String? profileImage;
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            profileName: widget.profileName,
            profileImage: widget.profileImage,
          ),
          const SearchScreen(),
          const ComingSoonScreen(),
          const DownloadsScreen(),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        comingSoonBadgeCount: 4,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
