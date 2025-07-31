import 'package:dartz/dartz.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/data/datasource/auth_local_data_src.dart';
import 'package:mustye/src/auth/data/datasource/auth_remote_data_src.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo{

  AuthRepoImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource, _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;


  @override
  RFuture<void> forgotPassword(String email) async{

    try{
      await _remoteDataSource.forgotPassword(email);

      return const Right(null);

    } on ServerException catch(e){

      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

    }

  }

  @override
  RFuture<LocalUser> googleSignIn() async{
     try{
      final result = await _remoteDataSource.googleSignIn();

      return Right(result);

    }on ServerException catch(e){

      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

    }
  }  

  @override
  RFuture<LocalUser> signIn(
    {
      required String email, 
      required String password,
    }) async{

    try{
      final result = await _remoteDataSource.signIn(
        email : email,
        password: password,
      );

      return Right(result);

    }on ServerException catch(e){

      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

    }
  }

  @override
  RFuture<void> signUp(
    {
      required String email, 
      required String fullName, 
      required String password,
    })async {

    try{
      await _remoteDataSource.signUp(
        email : email,
        fullName: fullName,
        password: password,
      );

      return const Right(null);

    }on ServerException catch(e){

      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

    }

  }

  @override
  RFuture<void> updateUser(
    {
      required UpdateUserAction action,
      dynamic userData,
    }) async{
    
    try{
      await _remoteDataSource.updateUser(
        action : action,
        userData: userData,
      );

      return const Right(null);

    }on ServerException catch(e){

      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

    }
  }
  
  @override
  RFuture<void> cacheUserData(LocalUser user) async{
    try{
      await _localDataSource.cacheUserData(user);

      return const Right(null);

    }on CacheException catch(e){

      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));

    }
  }
  
  @override
  RFuture<LocalUser> getUserCachedData() async{
    try{
      final user = await _localDataSource.getUserCachedData();

      return Right(user);

    }on CacheException catch(e){

      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));

    }
  }

}
