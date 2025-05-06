import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class SendMessage extends UseCaseWithParams<void, SendMessageParams> {
  const SendMessage(this._repo);

  final MessageRepo _repo;

  @override
  RFuture<void> call(SendMessageParams params) => _repo.sendMessage(
    sender: params.sender,
    reciever: params.reciever,
    message: params.message,
  ); 
}

class SendMessageParams extends Equatable{

  const SendMessageParams({
    required this.sender,
    required this.reciever,
    required this.message,
  });

  final LocalUser sender;
  final Chat reciever;
  final String message;


  @override
  List<Object?> get props => [sender, reciever];
  
}
