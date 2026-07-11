import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/home/bloc/home/home_bloc.dart';
import 'package:movieapp/features/home/bloc/home/home_event.dart';
import 'package:movieapp/features/home/bloc/home/home_state.dart';
import 'package:movieapp/shared/constants/assets/assets.dart';
import 'package:movieapp/shared/dependencyInjection/injection.dart';
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
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

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
                  child: _HeroSection(movie: feed.featured),
                ),
                SliverToBoxAdapter(
                  child: _PreviewsRow(movies: feed.popular),
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

class _HeroSection extends StatelessWidget {
  const _HeroSection({this.movie});

  final MovieModel? movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (movie != null)
            AppNetworkImage(
              url: movie!.backdropUrl.isNotEmpty
                  ? movie!.backdropUrl
                  : movie!.posterUrl,
            )
          else
            const ColoredBox(color: Color(0xFF1A1A1A)),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99000000),
                  Colors.transparent,
                  Color(0xCC000000),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _HomeTopBar(),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
            child: Column(
              children: [
                const _TopTenBadge(rank: 2, region: 'Nigeria'),
                SizedBox(height: 14.h),
                const _HeroActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, topInset + 2, 12.w, 0),
      child: Row(
        children: [
          Image.asset(netflixLogo, height: 28, fit: BoxFit.contain),
          SizedBox(width: 16.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavLabel('TV Shows'),
                _NavLabel('Movies'),
                _NavLabel('My List'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  const _NavLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TopTenBadge extends StatelessWidget {
  const _TopTenBadge({required this.rank, required this.region});

  final int rank;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 15.w,
          height: 15.h,
          decoration: BoxDecoration(
            //color: const Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2.r),
            border: Border.all(color: Colors.white)
          ),
          alignment: Alignment.center,
          child: Text(
            'TOP\n10',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 7.sp,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '#$rank in $region Today',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _IconAction(
            icon: Icons.add,
            label: 'My List',
            onTap: () {},
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 45.h,
            width: 110.w,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4C4C4),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              icon: Icon(Icons.play_arrow, size: 26.r),
              label: Text(
                'Play',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: _IconAction(
            icon: Icons.info_outline,
            label: 'Info',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26.r),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _PreviewsRow extends StatelessWidget {
  const _PreviewsRow({required this.movies});

  final List<MovieModel> movies;



  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final size = 110.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          child: Text(
            'Previews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: size + 4.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: movies.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final movie = movies[index];
             // final border = _borderColors[index % _borderColors.length];
              return SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      
                      ),
                      padding: EdgeInsets.all(2.r),
                      child: ClipOval(
                        child: AppNetworkImage(
                          url: movie.posterUrl,
                          width: size,
                          height: size,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6.w,
                      right: 6.w,
                      bottom: 10.h,
                      child: Text(
                        movie.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          shadows: const [
                            Shadow(blurRadius: 4, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MovieRow extends StatelessWidget {
  const _MovieRow({
    required this.title,
    required this.movies,
    this.tall = false,
  });

  final String title;
  final List<MovieModel> movies;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final height = tall ? 220.h : 150.h;
    final width = tall ? 140.w : 105.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 8.h),
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
