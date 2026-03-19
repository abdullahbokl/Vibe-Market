import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_mode_state.dart';
import 'theme_preference.dart';
import 'theme_preference_repository.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit(this._repository) : super(const ThemeModeState.initial());

  final ThemePreferenceRepository _repository;

  Future<void> loadPreference() async {
    final ThemePreference preference = await _repository.loadPreference();
    emit(state.copyWith(preference: preference));
  }

  Future<void> setPreference(ThemePreference preference) async {
    if (preference == state.preference) {
      return;
    }
    await _repository.savePreference(preference);
    emit(state.copyWith(preference: preference));
  }
}
