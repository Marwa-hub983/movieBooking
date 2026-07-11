// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/coming_soon/bloc/coming_soon_bloc.dart' as _i84;
import '../../features/home/bloc/home/home_bloc.dart' as _i854;
import '../../features/search/bloc/search/search_bloc.dart' as _i79;
import '../../features/home/data/datasources/movie_api_service.dart' as _i364;
import '../../features/home/data/repositories/movie_repository_impl.dart'
    as _i449;
import '../domain/repositories/movie_repository.dart' as _i897;
import '../network/dio_client.dart' as _i667;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i364.MovieApiService>(
      () => _i364.MovieApiService(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i897.MovieRepository>(
      () => _i449.MovieRepositoryImpl(gh<_i364.MovieApiService>()),
    );
    gh.factory<_i84.ComingSoonBloc>(
      () => _i84.ComingSoonBloc(gh<_i897.MovieRepository>()),
    );
    gh.factory<_i854.HomeBloc>(
      () => _i854.HomeBloc(gh<_i897.MovieRepository>()),
    );
    gh.factory<_i79.SearchBloc>(
      () => _i79.SearchBloc(gh<_i897.MovieRepository>()),
    );
    return this;
  }
}
