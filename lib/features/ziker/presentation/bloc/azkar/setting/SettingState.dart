
part of 'SettingBloc.dart';


abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class LoadingSettingState extends SettingState {}

class LoadedSettingState extends SettingState {
  final Setting setting;

  const LoadedSettingState({required this.setting});

  @override
  List<Object> get props => [setting];
}

class ErrorSettingState extends SettingState {
  final String message;

  const ErrorSettingState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageUpdateSettingState extends SettingState {
  final String message;

  MessageUpdateSettingState({required this.message});

  @override
  List<Object> get props => [message];
}