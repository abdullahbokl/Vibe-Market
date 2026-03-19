part of 'bootstrap_cubit.dart';

class BootstrapState extends Equatable {
  const BootstrapState({
    required this.status,
    required this.isOnline,
    required this.isDemoMode,
  });

  factory BootstrapState.initial() {
    return const BootstrapState(
      status: BootstrapStatus.initial,
      isOnline: true,
      isDemoMode: true,
    );
  }

  final BootstrapStatus status;
  final bool isOnline;
  final bool isDemoMode;

  BootstrapState copyWith({
    BootstrapStatus? status,
    bool? isOnline,
    bool? isDemoMode,
  }) {
    return BootstrapState(
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      isDemoMode: isDemoMode ?? this.isDemoMode,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, isOnline, isDemoMode];
}
