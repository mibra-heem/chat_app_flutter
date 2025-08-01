import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/repos/audio_call_repo.dart';

class ActivateIncomingAudioCall
    extends UseCaseWithParams<void, AudioCall> {
  ActivateIncomingAudioCall(this._repo);

  final AudioCallRepo _repo;

  @override
  RFuture<void> call(AudioCall call) =>
      _repo.activateIncomingCall(call);
}
