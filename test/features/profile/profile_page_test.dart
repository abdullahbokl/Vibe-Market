import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vibemarket/app/di/service_locator.dart';
import 'package:vibemarket/core/config/app_environment.dart';
import 'package:vibemarket/core/theme/app_theme.dart';
import 'package:vibemarket/core/theme/theme_mode_cubit.dart';
import 'package:vibemarket/core/theme/theme_preference.dart';
import 'package:vibemarket/core/theme/theme_preference_repository.dart';
import 'package:vibemarket/features/auth/domain/entities/auth_session.dart';
import 'package:vibemarket/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vibemarket/features/profile/presentation/pages/profile_page.dart';

class _FakeThemePreferenceRepository implements ThemePreferenceRepository {
  @override
  Future<ThemePreference> loadPreference() async => ThemePreference.system;

  @override
  Future<void> savePreference(ThemePreference preference) async {}
}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late _MockAuthCubit authCubit;

  setUp(() async {
    authCubit = _MockAuthCubit();
    await locator.reset();
    locator.registerSingleton<AppEnvironment>(const AppEnvironment(
      supabaseUrl: '',
      supabaseAnonKey: '',
      stripePublishableKey: '',
      deepLinkScheme: 'vibemarket',
      appFlavor: 'test',
      enableDemoMode: true,
    ));
  });

  testWidgets('profile page shows appearance controls for guests and members', (
    WidgetTester tester,
  ) async {
    when(() => authCubit.state).thenReturn(AuthState.initial());
    await tester.pumpWidget(_buildPage(authCubit));
    expect(find.text('Appearance'), findsOneWidget);

    when(() => authCubit.state).thenReturn(
      AuthState.initial().copyWith(
        session: const AuthSession.authenticated(
          AppUser(id: '1', email: 'member@test.com', displayName: 'Member'),
        ),
      ),
    );
    await tester.pumpWidget(_buildPage(authCubit));
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
  });
}

Widget _buildPage(AuthCubit authCubit) {
  return MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<AuthCubit>.value(value: authCubit),
      BlocProvider<ThemeModeCubit>(
        create: (_) => ThemeModeCubit(_FakeThemePreferenceRepository()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: ProfilePage(
        onOpenSignIn: () {},
        onOpenWishlist: () {},
        onOpenOrders: () {},
      ),
    ),
  );
}
