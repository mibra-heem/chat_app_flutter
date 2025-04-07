import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/data/datasource/contact_remote_data_src.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class ContactRepoImpl implements ContactRepo{

  ContactRepoImpl(this._remoteDataSrc);

  final ContactRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<List<LocalUser>> getContacts() async{
    try{
      final result = await _remoteDataSrc.getContacts(); 
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
  
}
