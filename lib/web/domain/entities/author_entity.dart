import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {
  const AuthorEntity({
    required this.name,
    required this.profileImage,
  });

  final String name;
  final String profileImage;

  AuthorEntity copyWith({
    String? name,
    String? profileImage,
  }) => AuthorEntity(
    name: name ?? this.name,
    profileImage: profileImage ?? this.profileImage,
  );

  @override
  List<Object?> get props => [name, profileImage];
}