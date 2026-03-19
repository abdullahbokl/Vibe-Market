import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VibeBlocObserver extends BlocObserver {
  const VibeBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('[${bloc.runtimeType}] $change');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('[${bloc.runtimeType}] $error');
    }
  }
}
