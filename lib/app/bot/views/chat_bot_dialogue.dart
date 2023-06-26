import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';

import 'package:stuverse_app/app/bot/models/bot_message.dart';

import '../widgets/message_tile.dart';
import '../cubit/bot_cubit.dart';

class ChatBotDialogue extends StatefulWidget {
  const ChatBotDialogue({
    super.key,
  });

  @override
  State<ChatBotDialogue> createState() => _ChatBotDialogueState();
}

class _ChatBotDialogueState extends State<ChatBotDialogue> {
  late final User _user;
  @override
  void initState() {
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    context.read<BotCubit>().fetchBotMessages(userId: _user.id);
    super.initState();
  }

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<BotMessage> messageList = [];
    return Scaffold(
      body: BlocConsumer<BotCubit, BotState>(listener: (context, state) {
        // TODO: implement listener
      }, builder: (context, state) {
        if (state is BotLoaded) {
          messageList = state.messageList;
        }
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messageList[index];

                      return MessageTile(
                        message: message,
                        isSender: !message.isBot,
                      );
                    },
                  ),
                ),
                Divider(),
                IgnorePointer(
                  ignoring: state is BotLoading,
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
                        ),
                        if (state is BotLoading)
                          LoadingAnimationWidget.newtonCradle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 30)
                        else
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (_textController.text.isNotEmpty) {
                                context.read<BotCubit>().sendMessageToBot(
                                      question: _textController.text,
                                      user: _user.id,
                                    );
                                _textController.clear();
                                _scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
