import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/features/home/bloc/search_bloc.dart';
import 'package:movieapp/features/home/bloc/search_event.dart';
import 'package:movieapp/features/home/bloc/search_state.dart';
import 'package:movieapp/shared/di/injection.dart';
import 'package:movieapp/shared/routes/routes.dart';
import 'package:movieapp/shared/utils/responsive.dart';
import 'package:movieapp/shared/widgets/app_network_image.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: const Color(0xFFE50914),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchQueryChanged(value));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              context.read<SearchBloc>().add(const SearchCleared());
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(routeHomeScreen),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return switch (state) {
            SearchInitial() => Center(
                child: Text(
                  'Type to search movies',
                  style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                ),
              ),
            SearchLoading() => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            SearchEmpty(:final query) => Center(
                child: Text(
                  'No results for "$query"',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ),
            SearchError(:final failure) => Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    failure.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
              ),
            SearchLoaded(:final movies) => GridView.builder(
                padding: EdgeInsets.all(12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 0.65,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppNetworkImage(
                          url: movie.posterUrl,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  );
                },
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
