import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/audio_call/domain/entities/incoming_audio_call.dart';

class IncomingAudioCallModel extends IncomingAudioCall {
  const IncomingAudioCallModel({
    required super.callerId,
    required super.receiverId,
    required super.channelName,
    required super.isCalling,
    super.timestamp,
  });

  const IncomingAudioCallModel.empty() : super.empty();

  IncomingAudioCallModel.fromMap(DataMap map)
    : super(
        callerId: map['callerId'] as String,
        receiverId: map['receiverId'] as String,
        channelName: map['channelName'] as String,
        timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isCalling: map['isCalling'] as bool,
      );

  IncomingAudioCallModel copyWith({
    String? callerId,
    String? recieverId,
    String? channelName,
    DateTime? timestamp,
    bool? isCalling,
  }) {
    return IncomingAudioCallModel(
      callerId: callerId ?? this.callerId,
      receiverId: recieverId ?? this.receiverId,
      channelName: channelName ?? this.channelName,
      timestamp: timestamp ?? this.timestamp,
      isCalling: isCalling ?? this.isCalling,
    );
  }

  DataMap toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'channelName': channelName,
      'timestamp': FieldValue.serverTimestamp(),
      'isCalling': isCalling,
    };
  }
}
