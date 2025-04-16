import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/repo/chat_repo.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class GetChats extends UseCaseWithoutParams<List<Contact>>{

  GetChats(this._repo);

  final ChatRepo _repo;
  
  @override
  RFuture<List<Contact>> call() => _repo.getChats();
  
}
