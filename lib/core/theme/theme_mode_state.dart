import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'theme_preference.dart';

class ThemeModeState extends Equatable {
  const ThemeModeState({required this.preference});

  const ThemeModeState.initial() : this(preference: ThemePreference.system);

  final ThemePreference preference;

  ThemeMode get themeMode => preference.themeMode;

  ThemeModeState copyWith({ThemePreference? preference}) {
    return ThemeModeState(preference: preference ?? this.preference);
  }

  @override
  List<Object> get props => <Object>[preference];
}
