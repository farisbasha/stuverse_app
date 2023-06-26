import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/chat/cubit/chat_home_cubit.dart';

import 'package:stuverse_app/utils/common_utils.dart';

import '../widgets/conversation_tile.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  late final User _user;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    context.read<ChatHomeCubit>().getConversationList(
          userId: _user.id,
        );

    _tabController = TabController(vsync: this, length: 2);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatHomeCubit, ChatHomeState>(
      listener: (context, state) {
        if (state is ChatHomeError) {
          CommonUtils.showSnackbar(context,
              message: state.message,
              isError: true,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: "Retry",
                onPressed: () {
                  context.read<ChatHomeCubit>().getConversationList(
                        userId: _user.id,
                      );
                },
              ));
        }
      },
      builder: (context, state) {
        if (state is ChatHomeLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          );
        } else if (state is ChatHomeLoaded) {
          final sendMsgs = state.sendConversations;
          final receivedMsgs = state.receiveConversations;

          return SafeArea(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Send Messages'),
                    Tab(text: 'Received Messages'),
                  ],
                  onTap: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                    context.read<ChatHomeCubit>().getConversationList(
                          userId: _user.id,
                        );
                  },
                ),
                if (_selectedIndex == 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            for (final conversation in sendMsgs)
                              CoversationTile(
                                conversation: conversation,
                                isSender: true,
                                user: _user,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            for (final conversation in receivedMsgs)
                              CoversationTile(
                                conversation: conversation,
                                isSender: false,
                                user: _user,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Container(); // Placeholder for other states
        }
      },
    );
  }
}
