import 'package:equatable/equatable.dart';

class IncomingAudioCall extends Equatable {
  const IncomingAudioCall({
    required this.callerId,
    required this.receiverId,
    required this.channelName,
    required this.isCalling,
    this.timestamp,
  });

  const IncomingAudioCall.empty()
    : this(
        callerId: 'empty.callerId',
        receiverId: 'empty.receiverId',
        channelName: 'empty.channelName',
        isCalling: false,
      );

  final String callerId;
  final String receiverId;
  final String channelName;
  final bool isCalling;
  final DateTime? timestamp;

  @override
  List<Object?> get props => [
    callerId,
    receiverId,
    channelName,
    isCalling,
    timestamp,
  ];

  @override
  String toString() {
    return 'IncomingAudioCall{callerId : $callerId, receiverId : $receiverId, '
        'channelName : $channelName, isCalling: $isCalling, '
        'timestamp: $timestamp}';
  }
}
