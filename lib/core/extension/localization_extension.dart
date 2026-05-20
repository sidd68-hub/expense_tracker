import 'package:expense_tracker/l10/app_localizations.dart';
import 'package:flutter/cupertino.dart';

extension AppLocal on BuildContext{
  AppLocalizations get loc => AppLocalizations.of(this);
}