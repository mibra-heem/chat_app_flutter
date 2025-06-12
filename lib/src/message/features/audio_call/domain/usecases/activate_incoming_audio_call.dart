import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/audio_call/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/audio_call/domain/repos/audio_call_repo.dart';

class ActivateIncomingAudioCall
    extends UseCaseWithParams<void, IncomingAudioCall> {
  ActivateIncomingAudioCall(this._repo);

  final AudioCallRepo _repo;

  @override
  RFuture<void> call(IncomingAudioCall call) =>
      _repo.activateIncomingCall(call);
}
