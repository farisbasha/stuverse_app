import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/chat/cubit/chat_home_cubit.dart';
import 'package:stuverse_app/app/chat/views/chat_screen.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../model/conversation.dart';

class CoversationTile extends StatefulWidget {
  const CoversationTile({
    super.key,
    required this.conversation,
    required this.isSender,
    required this.user,
  });

  final Conversation conversation;
  final bool isSender;
  final User user;

  @override
  State<CoversationTile> createState() => _CoversationTileState();
}

class _CoversationTileState extends State<CoversationTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
          tileColor: Theme.of(context).colorScheme.onInverseSurface,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.conversation.product.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Positioned(
                top: -10,
                left: -10,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.isSender
                      ? widget.conversation.receiver.image
                      : widget.conversation.sender.image),
                  radius: 14,
                ),
              ),
            ],
          ),
          title: Text(
              widget.isSender
                  ? widget.conversation.receiver.firstName
                  : widget.conversation.sender.firstName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.conversation.product.title,
                  style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 5),
              Builder(builder: (context) {
                String txt = "";
                if (widget.conversation.recent_message_sender != null) {
                  if (widget.conversation.recent_message_sender!.id ==
                      widget.user.id) {
                    txt = "You: ";
                  } else {
                    txt = "${widget.conversation.recent_message_sender!.firstName}: ";
                  }
                }
                return Row(
                  children: [
                    Text(
                      txt,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Expanded(
                      child: Text(
                        widget.conversation.recent_message ?? "",
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.conversation.recent_message_time != null)
                      Text(
                        CommonUtils.formatChatDate(
                            widget.conversation.recent_message_time!),
                        style: const TextStyle(fontSize: 10),
                      ),
                  ],
                );
              }),
            ],
          ),
          trailing: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.arrow_forward_ios),
              if (widget.conversation.recent_message_sender != null)
                if (!widget.conversation.isRead &&
                    widget.conversation.recent_message_sender!.id !=
                        widget.user.id)
                  Positioned(
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          onTap: () {
            CommonUtils.navigatePush(
                context, ChatScreen(conversation: widget.conversation));
            if (widget.conversation.recent_message_sender != null) {
              if (!widget.conversation.isRead &&
                  widget.conversation.recent_message_sender!.id !=
                      widget.user.id) {
                setState(() {
                  widget.conversation.isRead = true;
                });
                context
                    .read<ChatHomeCubit>()
                    .readConversation(conversationId: widget.conversation.id);
              }
            }
          }),
    );
  }
}
