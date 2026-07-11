import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/home/bloc/search/search_bloc.dart';
import 'package:movieapp/features/home/bloc/search/search_event.dart';
import 'package:movieapp/features/home/bloc/search/search_state.dart';
import 'package:movieapp/shared/di/injection.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/utils/responsive.dart';
import 'package:movieapp/shared/widgets/app_network_image.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>()..add(const SearchStarted()),
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
            child: _SearchBar(
              controller: _controller,
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              onClear: () {
                _controller.clear();
                context.read<SearchBloc>().add(const SearchCleared());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return switch (state) {
                  SearchInitial() || SearchLoading() => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE50914)),
                  ),
                  SearchTopLoaded(:final movies) => _TopSearchesList(
                    title: 'Top Searches',
                    movies: movies,
                  ),
                  SearchLoaded(:final movies) => _TopSearchesList(
                    title: 'Movies & TV',
                    movies: movies,
                  ),
                  SearchEmpty(:final query) => Center(
                    child: Text(
                      query.isEmpty
                          ? 'No top searches available.'
                          : 'No results for "$query"',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                  SearchError(:final failure) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        failure.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFF323232),
        borderRadius: BorderRadius.circular(6.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white70, size: 22.r),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search for a show, movie, genre, etc.',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: widget.onClear,
              child: Icon(Icons.close, color: Colors.white70, size: 20.r),
            )
          else
            Icon(Icons.mic, color: Colors.white70, size: 22.r),
        ],
      ),
    );
  }
}

class _TopSearchesList extends StatelessWidget {
  const _TopSearchesList({required this.title, required this.movies});

  final String title;
  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemBuilder: (context, index) {
              return _TopSearchTile(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _TopSearchTile extends StatelessWidget {
  const _TopSearchTile({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ColoredBox(
        color: const Color(0xFF424242),
        child: Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Row(
            children: [
              AppNetworkImage(
                url: movie.backdropUrl.isNotEmpty
                    ? movie.backdropUrl
                    : movie.posterUrl,
                width: 146.w,
                height: 76.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 1.5),
                ),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 20.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
