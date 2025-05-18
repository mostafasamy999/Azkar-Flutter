


import 'package:equatable/equatable.dart';

import 'Hadith.dart';

class Ziker extends Equatable {
  final int id;
  final String name;
  final List<Hadith> arr;

  const Ziker(
     this.id,
     this.name,
     this.arr,
  );

  @override
  List<Object?> get props => [id, name, arr];
}
