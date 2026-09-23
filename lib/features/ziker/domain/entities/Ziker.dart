


import 'package:equatable/equatable.dart';

import 'Hadith.dart';

class Ziker extends Equatable {
  final int id;
  final String name;
  final List<Hadith> arr;
  final bool isEmportant;
  final bool hasCounter;

  const Ziker(
     this.id,
     this.name,
     this.arr,
      this.isEmportant,
      {this.hasCounter = true}
  );

  @override
  List<Object?> get props => [id, name, arr,isEmportant, hasCounter];
}
