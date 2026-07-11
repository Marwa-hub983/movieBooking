import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_bloc.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_event.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_state.dart';
import 'package:movieapp/shared/di/injection.dart';
import 'package:movieapp/shared/models/movie_model.dart';
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
    return BlocBuilder<ComingSoonBloc, ComingSoonState>(
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
              child: Padding(
                padding: EdgeInsets.all(24.w),
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: _NotificationsHeader(
                        movies: movies.take(2).toList(),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= movies.length) {
                          return Padding(
                            padding: EdgeInsets.all(24.w),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFE50914),
                              ),
                            ),
                          );
                        }
                        return _ComingSoonCard(movie: movies[index]);
                      },
                      childCount: movies.length + (isLoadingMore ? 1 : 0),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                ],
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.movies});

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  color: Color(0xFFE50914),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 12.r,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          for (final movie in movies) ...[
            _NotificationTile(movie: movie),
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppNetworkImage(
          url: movie.backdropUrl.isNotEmpty
              ? movie.backdropUrl
              : movie.posterUrl,
          width: 110.w,
          height: 62.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Arrival',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                _shortDate(movie.releaseDate),
                style: TextStyle(color: Colors.white54, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: movie.backdropUrl.isNotEmpty
                ? movie.backdropUrl
                : movie.posterUrl,
            width: double.infinity,
            height: 210.h,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                //       Text(
                //         _comingLabel(movie.releaseDate),
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       Text(
                //         movie.title,
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20.sp,
                //           fontWeight: FontWeight.w800,
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       Text(
                //         movie.overview.isEmpty
                //             ? 'No overview available.'
                //             : movie.overview,
                //         maxLines: 4,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           color: Colors.white70,
                //           fontSize: 13.sp,
                //           height: 1.4,
                //         ),
                //       ),
                //       if (movie.genresLine.isNotEmpty) ...[
                //         SizedBox(height: 10.h),
                //         Text(
                //           movie.genresLine,
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //           style: TextStyle(
                //             color: Colors.white54,
                //             fontSize: 12.sp,
                //           ),
                //         ),
                //       ],
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActionButton(
                      icon: Icons.notifications_sharp,
                      label: 'Remind Me',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reminder set for ${movie.title}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 14.h),
                    _ActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Share ${movie.title}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                       Text(
                        _comingLabel(movie.releaseDate),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movie.overview.isEmpty
                            ? 'No overview available.'
                            : movie.overview,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                      if (movie.genresLine.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        Text(
                          movie.genresLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 64.w,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24.r),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}

String _shortDate(String? raw) {
  final date = _parseDate(raw);
  if (date == null) return '';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String _comingLabel(String? raw) {
  final date = _parseDate(raw);
  if (date == null) return 'Coming Soon';
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return 'Coming ${months[date.month - 1]} ${date.day}';
}

DateTime? _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}
