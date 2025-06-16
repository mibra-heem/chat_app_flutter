import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/data/datasource/audio_call_remote_data_src.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/repos/audio_call_repo.dart';

class AudioCallRepoImpl implements AudioCallRepo {
  const AudioCallRepoImpl(this._remoteDataSrc);

  final AudioCallRemoteDataSrc _remoteDataSrc;

  @override
  RFuture<void> activateIncomingCall(AudioCall call) async {
    try {
      await _remoteDataSrc.activateIncomingAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> acceptAudioCall(AudioCall call) async {
    try {
      await _remoteDataSrc.acceptAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> rejectAudioCall(AudioCall call) async {
    try {
      await _remoteDataSrc.rejectAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> endAudioCall(AudioCall call) async {
    try {
      await _remoteDataSrc.endAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
  
  @override
  RFuture<void> cancelAudioCall(AudioCall call) async {
    try {
      await _remoteDataSrc.cancelAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
