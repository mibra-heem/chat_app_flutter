import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/audio_call/domain/entities/incoming_audio_call.dart';

abstract class AudioCallRepo {
  const AudioCallRepo();

  RFuture<void> activateIncomingCall(IncomingAudioCall call);

}
