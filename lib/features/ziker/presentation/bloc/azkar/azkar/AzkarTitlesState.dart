
part of 'AzkarBloc.dart';


abstract class AzkarState extends Equatable {
  const AzkarState();

  @override
  List<Object> get props => [];
}

class AzkarInitial extends AzkarState {}

class LoadingAzkarState extends AzkarState {}

class LoadedAzkarState extends AzkarState {
  final List<Ziker> azkarWithoutPray;
  final List<Ziker> pryaAzkar;

  const LoadedAzkarState({required this.azkarWithoutPray ,required this.pryaAzkar});

  @override
  List<Object> get props => [azkarWithoutPray,pryaAzkar];
}

class ErrorAzkarState extends AzkarState {
  final String message;

  const ErrorAzkarState({required this.message});

  @override
  List<Object> get props => [message];
}