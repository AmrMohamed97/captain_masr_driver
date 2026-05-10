part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSendMessageState extends ChatState {}

final class ChatLoadingState extends ChatState {}

final class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState({required this.error});
}

final class GetChatSuccessState extends ChatState {}

final class SendMessageErrorState extends ChatState {}

final class SendMessageSuccessState extends ChatState {}
