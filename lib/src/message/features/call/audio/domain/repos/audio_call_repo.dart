import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

abstract class AudioCallRepo {
  const AudioCallRepo();

  RFuture<void> activateIncomingCall(AudioCall call);
  RFuture<void> acceptAudioCall(AudioCall call);
  RFuture<void> rejectAudioCall(AudioCall call);
  RFuture<void> cancelAudioCall(AudioCall call);
  RFuture<void> endAudioCall(AudioCall call);

}
