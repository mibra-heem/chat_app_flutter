import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/data/datasource/message_remote_data_src.dart';
import 'package:mustye/src/message/domain/entity/message.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class MessageRepoImpl implements MessageRepo {
  const MessageRepoImpl(this._remoteDataSrc);

  final MessageRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  }) async {
    try {
      await _remoteDataSrc.sendMessage(
        sender: sender,
        reciever: reciever,
        message: message,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> deleteMessages({
    required List<Message> messages,
    required String chatId,
  }) async {
    try {
      await _remoteDataSrc.deleteMessages(messages: messages, chatId: chatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> setActiveChatId({required String? activeChatId}) async {
    try {
      await _remoteDataSrc.setActiveChatId(activeChatId: activeChatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
