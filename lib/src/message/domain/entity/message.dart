import 'package:equatable/equatable.dart';

class Message extends Equatable{

  const Message({
    required this.msg,
    required this.msgTime,
    required this.senderId,
    required this.recieverId,
    required this.senderName,
    required this.recieverName,
    required this.senderEmail,
    required this.recieverEmail, 
    required this.senderImage,
    required this.recieverImage,
  });

  Message.empty() : this(
    msg: '',
    msgTime: DateTime.now(),
    senderId: '',
    recieverId: '',
    senderName: '',
    recieverName: '',
    senderEmail: '',
    recieverEmail: '',
    senderImage: '',
    recieverImage: '',
  );

  final String senderId;
  final String recieverId;
  final String senderName;
  final String recieverName;
  final String senderEmail;
  final String recieverEmail;
  final String senderImage;
  final String recieverImage;
  final String msg;
  final DateTime msgTime;

  @override
  List<Object?> get props => [
    senderId, recieverId,
    senderName, recieverName,
    senderEmail, recieverEmail,
    senderImage, recieverImage,
    msg, msgTime, 
  ];

  @override
  String toString(){
    return 'Message{msg : $msg, msgTime: $msgTime, senderName: $senderName '
    'recieverName: $recieverName}';
  }
}
