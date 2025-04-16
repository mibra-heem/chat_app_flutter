import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/data/datasource/chat_remote_data_src.dart';
import 'package:mustye/src/chat/domain/repo/chat_repo.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class ChatRepoImpl implements ChatRepo{

  ChatRepoImpl(this._remoteDataSrc);

  final ChatRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<List<Contact>> getChats() async{
    try{
      final contacts = await _remoteDataSrc.getChats(); 
      return Right(contacts);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
  
}
