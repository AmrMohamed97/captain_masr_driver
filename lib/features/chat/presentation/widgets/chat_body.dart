import '../../../../core/imports/imports.dart';
import 'chat_header.dart';
import 'chat_input.dart';
import 'chat_messages_list.dart';
import 'chat_suggested_messages.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Column(
          children: [
            //! Header
            const ChatHeader(),

            //! Messages
            const ChatMessagesList(),

            //! Suggested Messages
            const ChatSuggestedMessages(),

            SizedBox(height: 16.rH(context)),

            //! Chat Input
            const ChatInput(),
          ],
        );
      },
    );
  }
}
