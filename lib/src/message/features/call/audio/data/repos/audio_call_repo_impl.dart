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
  RFuture<void> activateIncomingCall(IncomingAudioCall call) async {
    try {
      await _remoteDataSrc.activateIncomingAudioCall(call);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  RFuture<void> deactivateIncomingCall() async {
    try {
      await _remoteDataSrc.deactivateIncomingAudioCall();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
