import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/repo/chat_repo.dart';

class MessageSeen extends UseCaseWithParams<void, MessageSeenParams>{

  MessageSeen(this._repo);

  final ChatRepo _repo;
  
  @override
  RFuture<void> call(MessageSeenParams params) => _repo.messageSeen(
    senderUid: params.senderUid,
  );
  
}

class MessageSeenParams extends Equatable{

  const MessageSeenParams({
    required this.senderUid,
  });

  final String senderUid;

  @override
  List<Object?> get props => [senderUid];
  
}
