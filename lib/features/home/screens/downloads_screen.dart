import 'package:flutter/material.dart';
import 'package:movieapp/shared/utils/responsive.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              'Smart Downloads',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              'Introducing Downloads For You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sit quam dui, vivamus bibendum ut. A morbi mi tortor ut '
              'felis non accumsan accumsan quis. Massa,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                height: 1.45,
              ),
            ),
            const Spacer(),
            Center(
              child: Container(
                width: 180.r,
                height: 180.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF424242),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0071EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                  'SETUP',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Material(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(4.r),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(4.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      'Find Something to Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}
