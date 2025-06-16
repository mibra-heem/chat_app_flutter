import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/enums/call.dart';
import 'package:mustye/core/extensions/enum_extension.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

class AudioCallModel extends AudioCall {
  const AudioCallModel({
    required super.uid,
    required super.callerId,
    required super.callerName,
    required super.callerEmail,
    required super.receiverId,
    required super.receiverName,
    required super.receiverEmail,
    super.callerImage,
    super.receiverImage,
    super.isCallOn,
    super.status,
    super.type,
    super.createdAt,
    super.endedAt,
  });

  const AudioCallModel.empty() : super.empty();

  factory AudioCallModel.fromMap(DataMap map) {
    return AudioCallModel(
      uid: map['uid'] as String,
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerEmail: map['callerEmail'] as String,
      callerImage: map['callerImage'] as String?,
      receiverId: map['receiverId'] as String,
      receiverName: map['receiverName'] as String,
      receiverEmail: map['receiverEmail'] as String,
      receiverImage: map['receiverImage'] as String?,
      status: CallStatusExt.toEnum(map['status'] as String),
      type: CallTypeExt.toEnum(map['type'] as String),
      isCallOn: map['isCallOn'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      endedAt: (map['endedAt'] as Timestamp?)?.toDate(),
    );
  }

  AudioCallModel copyWith({
    String? uid,
    String? callerId,
    String? callerName,
    String? callerEmail,
    String? callerImage,
    String? receiverId,
    String? receiverName,
    String? receiverEmail,
    String? receiverImage,
    CallStatus? status,
    CallType? type,
    bool? isCallOn,
    DateTime? createdAt,
    DateTime? endedAt,
  }) {
    return AudioCallModel(
      uid: uid ?? this.uid,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerEmail: callerEmail ?? this.callerEmail,
      callerImage: callerImage ?? this.callerImage,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      receiverImage: receiverImage ?? this.receiverImage,
      status: status ?? this.status,
      type: type ?? this.type,
      isCallOn: isCallOn ?? this.isCallOn,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'callerId': callerId,
      'callerName': callerName,
      'callerEmail': callerEmail,
      'callerImage': callerImage,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverImage': receiverImage,
      'status': status.name,
      'type': type.name,
      'isCallOn': isCallOn,
      'createdAt': createdAt,
      'endedAt': endedAt,
    };
  }
}
