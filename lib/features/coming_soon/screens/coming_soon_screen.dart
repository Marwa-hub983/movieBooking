import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_bloc.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_event.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_state.dart';
import 'package:movieapp/shared/di/injection.dart';
import 'package:movieapp/shared/routes/routes.dart';
import 'package:movieapp/shared/utils/responsive.dart';
import 'package:movieapp/shared/widgets/app_network_image.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ComingSoonBloc>()..add(const ComingSoonStarted()),
      child: const _ComingSoonView(),
    );
  }
}

class _ComingSoonView extends StatelessWidget {
  const _ComingSoonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Coming Soon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(routeHomeScreen),
        ),
      ),
      body: BlocBuilder<ComingSoonBloc, ComingSoonState>(
        builder: (context, state) {
          return switch (state) {
            ComingSoonInitial() || ComingSoonLoading() => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            ComingSoonEmpty() => Center(
                child: Text(
                  'No upcoming movies.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ),
            ComingSoonError(:final failure) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      failure.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ComingSoonBloc>()
                          .add(const ComingSoonRetried()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50914),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ComingSoonLoaded(
              :final movies,
              :final hasMore,
              :final isLoadingMore,
            ) =>
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 200 &&
                      hasMore &&
                      !isLoadingMore) {
                    context
                        .read<ComingSoonBloc>()
                        .add(const ComingSoonLoadMore());
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: movies.length + (isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    if (index >= movies.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE50914),
                          ),
                        ),
                      );
                    }

                    final movie = movies[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppNetworkImage(
                          url: movie.posterUrl,
                          width: 110.w,
                          height: 160.h,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (movie.releaseDate != null) ...[
                                SizedBox(height: 6.h),
                                Text(
                                  'Release: ${movie.releaseDate}',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                              SizedBox(height: 8.h),
                              Text(
                                movie.overview.isEmpty
                                    ? 'No overview available.'
                                    : movie.overview,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13.sp,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
