import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

class IncomingAudioCallModel extends IncomingAudioCall {
  const IncomingAudioCallModel({
    required super.callerId,
    required super.receiverId,
    required super.callerName,
    required super.callerEmail,
    required super.isCalling,
    super.callerImage,
    super.timestamp, 
  });

  const IncomingAudioCallModel.empty() : super.empty();

  IncomingAudioCallModel.fromMap(DataMap map)
    : super(
        callerId: map['callerId'] as String,
        receiverId: map['receiverId'] as String,
        callerName: map['callerName'] as String,
        callerEmail: map['callerEmail'] as String,
        callerImage: map['callerImage'] as String?,
        isCalling: map['isCalling'] as bool,
        timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  IncomingAudioCallModel copyWith({
    String? callerId,
    String? callerName,
    String? receiverId,
    String? callerEmail,
    String? callerImage,
    bool? isCalling,
    DateTime? timestamp,
  }) {
    return IncomingAudioCallModel(
      callerId: callerId ?? this.callerId,
      receiverId: receiverId ?? this.receiverId,
      callerName: callerName ?? this.callerName,
      callerEmail: callerEmail ?? this.callerEmail,
      callerImage: callerImage ?? this.callerImage,
      timestamp: timestamp ?? this.timestamp,
      isCalling: isCalling ?? this.isCalling,
    );
  }

  DataMap toMap() {
    return {
      'callerId': callerId,
      'receiverId' : receiverId,
      'callerName': callerName,
      'callerEmail': callerEmail,
      'callerImage': callerImage,
      'isCalling': isCalling,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
