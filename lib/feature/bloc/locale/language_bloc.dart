import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'language_event.dart';
import 'language_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(const Locale('en'))) {
    on<ChangeLocale>((event, emit) {
      emit(LocaleState(event.locale));
    });
  }
}
