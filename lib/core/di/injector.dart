import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:expense_tracker/core/network/api_client.dart';
import 'package:expense_tracker/core/network/dio_client.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/data/datasources/auth_remote_datasource_impl.dart';
import 'package:expense_tracker/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/feature/bloc/connectivity/connectivity_bloc.dart';
import 'package:expense_tracker/feature/bloc/locale/language_bloc.dart';
import 'package:expense_tracker/feature/bloc/theme/theme_bloc.dart';
import 'package:expense_tracker/feature/screen/home_view/data/datasources/home_remote_datasource.dart';
import 'package:expense_tracker/feature/screen/home_view/data/datasources/home_remote_datasource_impl.dart';
import 'package:expense_tracker/feature/screen/home_view/data/repositories/home_repository_impl.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/repositories/home_repositories.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/use_case/home_screen_use_case.dart';
import 'package:expense_tracker/feature/screen/home_view/presentation/bloc/home_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Network
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //dio
  sl.registerLazySingleton<Dio>(() => DioClient().client);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
    dio: sl<Dio>(),
    networkInfo: sl<NetworkInfo>(),
  ));

  // Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // // Use Cases
  // sl.registerLazySingleton(() => LoginUser(sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ConnectivityBloc(sl<Connectivity>()));
  sl.registerLazySingleton<LocaleBloc>(() => LocaleBloc());
  sl.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  //Home Screen
  sl.registerLazySingleton(() => HomeScreenUseCase(sl()));
  sl.registerLazySingleton(() => HomeBloc(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()));
}
