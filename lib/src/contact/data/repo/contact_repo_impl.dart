import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/data/datasource/contact_remote_data_src.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class ContactRepoImpl implements ContactRepo{

  ContactRepoImpl(this._remoteDataSrc);

  final ContactRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<List<Contact>> getContacts() async{
    try{
      final result = await _remoteDataSrc.getContacts(); 
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
  
  @override
  RFuture<void> addContact(Contact contact) async{
    try{
      await _remoteDataSrc.addContact(contact); 
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
  
}
