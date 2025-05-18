import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class UnKnownFailure extends Failure {
  final String? message;
  UnKnownFailure({
    required this.message
});
  @override
  List<Object?> get props => [message];
}

