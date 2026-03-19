import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_environment.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/bootstrap_status.dart';

part 'bootstrap_state.dart';

class BootstrapCubit extends Cubit<BootstrapState> {
  BootstrapCubit({
    required ConnectivityService connectivityService,
    required AppEnvironment environment,
    required AuthCubit authCubit,
  }) : _connectivityService = connectivityService,
       _environment = environment,
       _authCubit = authCubit,
       super(BootstrapState.initial());

  final ConnectivityService _connectivityService;
  final AppEnvironment _environment;
  final AuthCubit _authCubit;

  Future<void> bootstrap() async {
    if (state.status == BootstrapStatus.loading) {
      return;
    }

    emit(state.copyWith(status: BootstrapStatus.loading));
    final bool isOnline = await _connectivityService.isOnline();
    await _authCubit.hydrateSession();
    emit(
      state.copyWith(
        status: BootstrapStatus.ready,
        isOnline: isOnline,
        isDemoMode: _environment.isDemoMode,
      ),
    );
  }
}
