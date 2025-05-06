import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class ActivateChat extends UseCaseWithParams<void, String> {
  ActivateChat(this._repo);

  final MessageRepo _repo;

  @override
  RFuture<void> call(String? activeChatId) =>
      _repo.setActiveChatId(activeChatId: activeChatId);
}
