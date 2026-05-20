import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/config/theme/theme_type.dart';
import 'package:expense_tracker/config/theme/themes.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: AppTheme.getTheme(ThemeType.light))) {
    on<SetTheme>((event, emit) {
      emit(ThemeState(themeData: AppTheme.getTheme(event.themeType)));
    });
  }
}
