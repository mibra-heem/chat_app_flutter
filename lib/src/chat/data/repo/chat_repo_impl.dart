import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/data/datasource/chat_remote_data_src.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/domain/repo/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  ChatRepoImpl(this._remoteDataSrc);

  final ChatRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<void> deleteChat(List<Chat> chat) async {
    try {
      await _remoteDataSrc.deleteChat(chat);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> messageSeen({
    required String senderUid,
  }) async {
    try {
      await _remoteDataSrc.messageSeen(
        senderUid: senderUid,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
