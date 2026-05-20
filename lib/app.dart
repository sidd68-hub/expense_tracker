import 'package:expense_tracker/config/routes/app_routes.dart';
import 'package:expense_tracker/feature/bloc/locale/language_bloc.dart';
import 'package:expense_tracker/feature/bloc/locale/language_state.dart';
import 'package:expense_tracker/feature/bloc/theme/theme_bloc.dart';
import 'package:expense_tracker/feature/bloc/theme/theme_state.dart';
import 'package:expense_tracker/feature/connectivity/connectivty_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injector.dart';
import 'l10/app_localizations.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => sl<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocProvider<LocaleBloc>(
            create: (_) => sl<LocaleBloc>(),
            child: BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, localeState) {
                return MaterialApp.router(
                  locale: localeState.locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('hi'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  title: 'Flutter Demo',
                  theme: themeState.themeData,
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) =>
                      ConnectivityListener(child: child!,),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
