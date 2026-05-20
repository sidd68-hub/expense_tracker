import 'package:expense_tracker/core/di/injector.dart';
import 'package:expense_tracker/domain/usecase/login_use_case.dart';
import 'package:expense_tracker/feature/screen/login/bloc/login_bloc.dart';


void initLoginModule() {
  if (!sl.isRegistered<LoginUser>()) {
    sl.registerLazySingleton(() => LoginUser(sl()));
  }

  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory(() => LoginBloc(sl()));
  }
}
