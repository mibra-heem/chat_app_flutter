import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/data/datasource/message_remote_data_src.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class MessageRepoImpl implements MessageRepo{
  const MessageRepoImpl(this._remoteDataSrc);

  final MessageRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<void> sendMessage({
    required LocalUser user, 
    required Contact contact,
    required String message,
  }) async{
    try{
      await _remoteDataSrc.sendMessage(
        user: user, 
        contact: contact,
        message: message,
      );
      return const Right(null);      
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
}
