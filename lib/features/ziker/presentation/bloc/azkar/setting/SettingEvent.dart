
part of 'SettingBloc.dart';



abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}
class GetOldSettingEvent extends SettingEvent {}

class UpdateSettingEvent extends SettingEvent {
  final Setting setting;

  const UpdateSettingEvent({required this.setting});

  @override
  List<Object> get props => [setting];
}


