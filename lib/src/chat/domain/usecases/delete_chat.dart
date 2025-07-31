import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/domain/repo/chat_repo.dart';

class DeleteChat extends UseCaseWithParams<void, List<Chat>>{

  DeleteChat(this._repo);

  final ChatRepo _repo;
  
  @override
  RFuture<void> call(List<Chat> chat) => _repo.deleteChat(chat);
  
}
