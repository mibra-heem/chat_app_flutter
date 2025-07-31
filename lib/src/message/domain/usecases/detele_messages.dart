import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/domain/entity/message.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class DeleteMessages extends UseCaseWithParams<void, DeleteMessagesParams> {
  DeleteMessages(this._repo);

  final MessageRepo _repo;

  @override
  RFuture<void> call(DeleteMessagesParams params) =>
      _repo.deleteMessages(messages: params.messages, chatId: params.chatId);
}

class DeleteMessagesParams extends Equatable {
  const DeleteMessagesParams({required this.messages, required this.chatId});

  final List<Message> messages;
  final String chatId;

  @override
  List<Object?> get props => [messages, chatId];
}
