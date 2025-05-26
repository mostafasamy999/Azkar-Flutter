
import '../../domain/entities/Hadith.dart';
import '../../domain/entities/Ziker.dart';

class ZikerResponse extends Ziker {
  const ZikerResponse(
      int id, String name, List<Hadith> arr,{isImportant = false})
      : super(id, name, arr,isImportant );
}
