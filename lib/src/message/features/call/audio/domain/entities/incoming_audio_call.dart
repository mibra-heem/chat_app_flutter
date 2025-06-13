import 'package:equatable/equatable.dart';

class IncomingAudioCall extends Equatable {
  const IncomingAudioCall({
    required this.callerId,
    required this.receiverId,
    required this.callerName,
    required this.callerEmail,
    required this.isCalling,
    this.callerImage,
    this.timestamp,
  });

  const IncomingAudioCall.empty()
    : this(
        callerId: 'empty.callerId',
        receiverId: 'empty.receiverId',
        callerName: 'empty.callerName',
        callerEmail: 'empty.callerEmail',
        isCalling: false,
      );

  final String callerId;
  final String receiverId;
  final String callerName;
  final String callerEmail;
  final String? callerImage;
  final bool isCalling;
  final DateTime? timestamp;

  @override
  List<Object?> get props => [
    callerId,
    receiverId,
    callerName,
    callerEmail,
    callerImage,
    isCalling,
    timestamp,
  ];

  @override
  String toString() {
    return 'IncomingAudioCall{callerId : $callerId, receiverId : $receiverId, '
        'callerName : $callerName, callerEmail : $callerEmail, callerImage : '
        '$callerImage, isCalling : $isCalling, timestamp: $timestamp}';
  }
}
