import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemarket/core/theme/app_theme.dart';
import 'package:vibemarket/core/theme/theme_mode_cubit.dart';
import 'package:vibemarket/core/theme/theme_mode_state.dart';
import 'package:vibemarket/core/theme/theme_preference.dart';
import 'package:vibemarket/core/theme/theme_preference_repository.dart';
import 'package:vibemarket/features/profile/presentation/widgets/profile_appearance_section.dart';

class _FakeThemePreferenceRepository implements ThemePreferenceRepository {
  @override
  Future<ThemePreference> loadPreference() async => ThemePreference.system;

  @override
  Future<void> savePreference(ThemePreference preference) async {}
}

void main() {
  testWidgets('theme mode follows system by default and updates from UI', (
    WidgetTester tester,
  ) async {
    final ThemeModeCubit cubit = ThemeModeCubit(_FakeThemePreferenceRepository());
    await tester.pumpWidget(_ThemeHarness(cubit: cubit));

    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.system);
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.light);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.dark);
  });
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.cubit});

  final ThemeModeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeModeCubit>.value(
      value: cubit,
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (BuildContext context, ThemeModeState state) {
          return MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            home: const Scaffold(body: ProfileAppearanceSection()),
          );
        },
      ),
    );
  }
}
