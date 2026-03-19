import 'package:equatable/equatable.dart';

enum FailureType {
  network,
  authentication,
  cache,
  validation,
  configuration,
  notFound,
  payment,
  unexpected,
}

class Failure extends Equatable {
  const Failure({required this.type, required this.message});

  const Failure.network(String message)
    : this(type: FailureType.network, message: message);

  const Failure.authentication(String message)
    : this(type: FailureType.authentication, message: message);

  const Failure.cache(String message)
    : this(type: FailureType.cache, message: message);

  const Failure.validation(String message)
    : this(type: FailureType.validation, message: message);

  const Failure.configuration(String message)
    : this(type: FailureType.configuration, message: message);

  const Failure.notFound(String message)
    : this(type: FailureType.notFound, message: message);

  const Failure.payment(String message)
    : this(type: FailureType.payment, message: message);

  const Failure.unexpected(String message)
    : this(type: FailureType.unexpected, message: message);

  final FailureType type;
  final String message;

  @override
  List<Object?> get props => <Object?>[type, message];
}
