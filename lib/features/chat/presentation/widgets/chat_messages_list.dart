import 'dart:developer';

import '../../../../core/imports/imports.dart';
import 'message_card.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          current is GetChatSuccessState || current is SendMessageSuccessState,
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        log("Chat length: ${cubit.chat.length}");
        return Expanded(
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: cubit.scrollController,
            padding: EdgeInsets.symmetric(
              vertical: 24.rH(context),
              horizontal: 16.rW(context),
            ),
            itemCount: cubit.chat.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 13.rH(context));
            },
            itemBuilder: (context, index) {
              final bool isSender = context.read<GlobalCubit>().userModel?.id ==
                  cubit.chat[index].senderId;
              return MessageCard(
                isSender: isSender,
                model: cubit.chat[index],
              );
            },
          ),
        );
      },
    );
  }
}
