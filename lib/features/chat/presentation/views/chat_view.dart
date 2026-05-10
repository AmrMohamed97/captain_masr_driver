import '../../../../core/imports/imports.dart';
import '../widgets/chat_body.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.senderName,
    required this.receiverName,
    required this.receiverImage,
    required this.resolvedRequestType,
  });

  final int senderId, receiverId, chatId;
  final String senderName, receiverName, receiverImage, resolvedRequestType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        senderId: senderId,
        receiverId: receiverId,
        chatId: chatId,
        senderName: senderName,
        receiverName: receiverName,
        receiverImage: receiverImage,
        requestType: resolvedRequestType,
      ),
      child: const Scaffold(
        body: ChatBody(),
      ),
    );
  }
}
