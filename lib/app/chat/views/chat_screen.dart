import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/chat/cubit/chat_home_cubit.dart';
import 'package:stuverse_app/app/chat/cubit/chat_screen/chat_screen_cubit.dart';
import 'package:stuverse_app/app/chat/model/conversation.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';

import '../widgets/chat_message_tile.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.conversation});
  final Conversation conversation;
  static bool isActive = false;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Conversation _conversation;
  @override
  void initState() {
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    _conversation = widget.conversation;
    _messageStream = FirebaseFirestore.instance
        .collection('msg')
        .doc(_conversation.id.toString())
        .collection('messages')
        .orderBy("sentAt", descending: true)
        .limit(30)
        .snapshots();

    if (_user.id == _conversation.sender.id) {
      _userName = _conversation.receiver.firstName;
    } else {
      _userName = _conversation.sender.firstName;
    }
    super.initState();
    ChatScreen.isActive = true;
  }

  @override
  void dispose() {
    ChatScreen.isActive = false;
    super.dispose();
  }

  void fetchConversationAgain() {
    context.read<ChatHomeCubit>().getConversationList(
          userId: _user.id,
        );
  }

  bool _showSnackbar = true;

  late String _userName;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  late final Stream<QuerySnapshot> _messageStream;
  late User _user;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("Popping");
        context
            .read<ChatHomeCubit>()
            .readConversation(conversationId: widget.conversation.id);

        widget.conversation.isRead = true;
        fetchConversationAgain();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_userName),
        ),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _messageStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Something went wrong"),
                            SvgAssetImage(
                              assetName: AppImages.empty,
                              color: Theme.of(context).colorScheme.primary,
                              width: 200,
                              height: 200,
                            )
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: data.length,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              final message = data[index].get("message");
                              bool isSender =
                                  data[index].get("sentBy") == _user.id;
                              return ChatMessageTile(
                                time: data[index].get("sentAt"),
                                message: message,
                                isSender: isSender,
                                image: isSender
                                    ? _user.image
                                    : _conversation.receiver.image,
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: LoadingAnimationWidget.halfTriangleDot(
                                color: Theme.of(context).colorScheme.primary,
                                size: 30),
                          ),
                        ],
                      ),
                    );
                  }),
              Divider(),
              BlocBuilder<ChatScreenCubit, ChatScreenState>(
                builder: (context, state) {
                  return IgnorePointer(
                    ignoring: state is ChatScreenLoading,
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).cardColor),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                              ),
                            ),
                          ),
                          if (state is ChatScreenLoading)
                            LoadingAnimationWidget.newtonCradle(
                                color: Theme.of(context).colorScheme.primary,
                                size: 30)
                          else
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                if (_textController.text.isNotEmpty) {
                                  context.read<ChatScreenCubit>().sendMessage(
                                        convId: _conversation.id,
                                        message: _textController.text,
                                        sender: _user.id,
                                      );
                                  _textController.clear();
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
