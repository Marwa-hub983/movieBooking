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
            SizedBox(height: 8.h),
            Text(
              'Smart Downloads',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Introducing Downloads For You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
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
               SizedBox(height: 10.h),
            //const Spacer(flex: 2),
            Center(
              child: Container(
                width: 140.r,
                height: 140.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF424242),
                  shape: BoxShape.circle,
                ),
              ),
            ),
           SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 38.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0071EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
                child: Text(
                  'SETUP',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Material(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(3.r),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(3.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    child: Text(
                      'Find Something to Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
