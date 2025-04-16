import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mustye/src/chat/domain/usecases/get_chats.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required GetChats getChats,
  }) : 
    _getChats = getChats,

  super(ChatInitial());

  final GetChats _getChats;

  Future<void> getChats() async{
    emit(const LoadingChats());
    final result = await _getChats();

    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (chats) => emit(ChatsLoaded(chats)),
    );

  }
}
