


import 'package:equatable/equatable.dart';

import 'Hadith.dart';

class Ziker extends Equatable {
  final int id;
  final String name;
  final List<Hadith> arr;
  final bool isEmportant;

  const Ziker(
     this.id,
     this.name,
     this.arr,
      this.isEmportant
  );

  @override
  List<Object?> get props => [id, name, arr,isEmportant];
}
