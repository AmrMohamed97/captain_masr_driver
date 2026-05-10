import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/message_model.dart';
import '../../data/repo/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.senderName,
    required this.receiverName,
    this.receiverImage,
    required this.requestType,
  }) : super(ChatInitial()) {
    getChat();
  }

  final int senderId;
  final int receiverId;
  final int chatId;
  final String senderName;
  final String receiverName;
  final String? receiverImage;
  final String requestType;

  //! Get Chat
  DatabaseReference? db;
  StreamSubscription<DatabaseEvent>? childAddedSub;
  List<MessageModel> chat = [];

  Future<void> getChat() async {
    db = FirebaseDatabase.instance.ref("ride_chats/$chatId");
    log("Listening on ride_chats/$chatId");

    childAddedSub = db!.onValue.listen(
      (event) {
        try {
          final data = event.snapshot.value;
          log("Chat snapshot exists=${event.snapshot.exists}, type=${data.runtimeType}");

          if (data == null || !event.snapshot.exists) {
            chat.clear();
            emit(GetChatSuccessState());
            return;
          }

          Map<String, dynamic> rawMap = {};

          if (data is Map) {
            rawMap = Map<String, dynamic>.fromEntries(
              data.entries.map((e) => MapEntry(e.key.toString(), e.value)),
            );
          } else if (data is List) {
            for (int i = 0; i < data.length; i++) {
              if (data[i] != null) rawMap[i.toString()] = data[i];
            }
          }

          log("Messages found: ${rawMap.length}");

          final List<MessageModel> loaded = [];
          for (final entry in rawMap.entries) {
            final value = entry.value;
            if (value is Map) {
              try {
                final msgMap = Map<String, dynamic>.fromEntries(
                  value.entries.map((e) => MapEntry(e.key.toString(), e.value)),
                );
                final msg = MessageModel.fromJson(msgMap);
                loaded.add(msg);

                if (msg.isSeen == false && msg.receiverId == senderId) {
                  db?.child(entry.key).update({"is_seen": true});
                }
              } catch (e, st) {
                log("Error parsing message: $e\n$st");
              }
            }
          }

          log("Chat length after parse: ${loaded.length}");
          loaded.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
          chat = loaded;
          emit(GetChatSuccessState());
          // الـ scroll للأسفل فقط إذا كان المستخدم هو من أرسل آخر رسالة
          // أو كان موجودًا أساساً قرب الأسفل (أقل من 100px)
          final lastMsg = loaded.isNotEmpty ? loaded.last : null;
          final bool userSentLast = lastMsg?.senderId == senderId;
          final bool nearBottom = scrollController.hasClients &&
              (scrollController.position.maxScrollExtent -
                      scrollController.offset) <
                  100;
          if (userSentLast || nearBottom) {
            scrollJump();
          }
        } catch (e, st) {
          log("Error in chat listener: $e\n$st");
        }
      },
      onError: (e) => log("Firebase listener error: $e"),
    );
  }

  //! Send Message
  Future<void> sendMessage() async {
    final result = await sl<ChatRepo>().sendMessage(
      tripId: chatId,
      requestType: requestType,
      senderId: senderId,
      recieverId: receiverId,
      message: messageController.text,
    );
    result.fold(
      (error) => emit(SendMessageErrorState()),
      (message) => emit(SendMessageSuccessState()),
    );
  }

  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  void scrollJump() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Future<void> close() {
    childAddedSub?.cancel();
    db = null;
    return super.close();
  }
}
