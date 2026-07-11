import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/home/bloc/home/home_bloc.dart';
import 'package:movieapp/features/home/bloc/home/home_event.dart';
import 'package:movieapp/features/home/bloc/home/home_state.dart';
import 'package:movieapp/shared/constants/assets/assets.dart';
import 'package:movieapp/shared/di/injection.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/utils/responsive.dart';
import 'package:movieapp/shared/widgets/app_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.profileName = 'User',
    this.profileImage,
  });

  final String profileName;
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomeStarted(profileName: profileName)),
      child: _HomeView(profileImage: profileImage),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({this.profileImage});

  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            ),
          HomeEmpty() => _MessageView(
              message: 'No movies found.',
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeRetried()),
            ),
          HomeError(:final failure) => _MessageView(
              message: failure.message,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeRetried()),
            ),
          HomeLoaded(:final feed, :final profileName) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      if (feed.featured != null)
                        _Hero(movie: feed.featured!)
                      else
                        SizedBox(height: 280.h),
                      _TopBar(profileImage: profileImage),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieRow(
                    title: 'Previews',
                    movies: feed.popular,
                    circular: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieRow(
                    title: 'Continue Watching for $profileName',
                    movies: feed.nowPlaying,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieRow(
                    title: 'Popular on Netflix',
                    movies: feed.popular,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieRow(
                    title: 'Trending Now',
                    movies: feed.trending,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieRow(
                    title: 'Top Rated',
                    movies: feed.topRated,
                    tall: true,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              ],
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({this.profileImage});
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Image.asset(netflixLogo, height: 28.h, fit: BoxFit.contain),
            const Spacer(),
            if (profileImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Image.asset(
                  profileImage!,
                  width: 28.r,
                  height: 28.r,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.movie});
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: movie.backdropUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Colors.transparent,
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieRow extends StatelessWidget {
  const _MovieRow({
    required this.title,
    required this.movies,
    this.circular = false,
    this.tall = false,
  });

  final String title;
  final List<MovieModel> movies;
  final bool circular;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final height = circular ? 100.r : (tall ? 220.h : 160.h);
    final width = circular ? 100.r : (tall ? 140.w : 110.w);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 8.h),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: movies.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final movie = movies[index];
              if (circular) {
                return ClipOval(
                  child: AppNetworkImage(
                    url: movie.posterUrl,
                    width: width,
                    height: height,
                  ),
                );
              }
              return AppNetworkImage(
                url: movie.posterUrl,
                width: width,
                height: height,
                borderRadius: BorderRadius.circular(4.r),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
