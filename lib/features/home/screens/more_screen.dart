import 'package:flutter/material.dart';
import 'package:movieapp/shared/utils/responsive.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'More',
        style: TextStyle(color: Colors.white70, fontSize: 16.sp),
      ),
    );
  }
}
