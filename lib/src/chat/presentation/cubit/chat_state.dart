part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class LoadingChats extends ChatState{
  const LoadingChats();
}

class ChatsLoaded extends ChatState{
  const ChatsLoaded(this.chats);

  final List<Contact> chats;

  @override
  List<Object> get props => [chats];

}

class ChatError extends ChatState{
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
