import 'package:equatable/equatable.dart';
import 'package:mustye/core/enums/call.dart';

class AudioCall extends Equatable {
  const AudioCall({
    required this.uid,
    required this.callerId,
    required this.callerName,
    required this.callerEmail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    this.callerImage,
    this.receiverImage,
    this.status = CallStatus.ringing,
    this.type = CallType.audio,
    this.isCallOn = false,
    this.createdAt,
    this.endedAt,
  });

  const AudioCall.empty()
      : this(
          uid: 'empty.uid',
          callerId: 'empty.callerId',
          callerName: 'empty.callerName',
          callerEmail: 'empty.callerEmail',
          receiverId: 'empty.receiverId',
          receiverName: 'empty.receiverName',
          receiverEmail: 'empty.receiverEmail',
        );

  final String uid;
  final String callerId;
  final String callerName;
  final String callerEmail;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String? callerImage;
  final String? receiverImage;
  final CallStatus status;
  final CallType type;
  final bool isCallOn;
  final DateTime? createdAt;
  final DateTime? endedAt;

  @override
  List<Object?> get props => [
        uid,
        callerId,
        callerName,
        callerEmail,
        callerImage,
        receiverId,
        receiverName,
        receiverEmail,
        receiverImage,
        status,
        type,
        isCallOn,
        createdAt,
        endedAt,
      ];

  @override
  String toString() {
    return 'AudioCall{uid: $uid, callerId: $callerId, callerName: $callerName, '
        'receiverId: $receiverId, receiverName: $receiverName, '
        'status: $status, type: $type, isCallOn: $isCallOn, '
        'createdAt: $createdAt, endedAt: $endedAt}';
  }
}
