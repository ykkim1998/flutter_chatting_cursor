import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/chat_memory.dart';
import '../widgets/chat_message_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatMemory(),
      child: const ChatScreenContent(),
    );
  }
}

class ChatScreenContent extends StatefulWidget {
  const ChatScreenContent({super.key});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final chatMemory = context.read<ChatMemory>();
    
    // 사용자 메시지 추가
    chatMemory.addMessage(text, true);
    
    // AI 응답 시뮬레이션 (실제로는 서버 통신 코드로 대체)
    Future.delayed(const Duration(seconds: 1), () {
      chatMemory.addMessage("AI의 응답: $text", false);
    });

    _textController.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('채팅'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatMemory>(
                builder: (context, chatMemory, child) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: chatMemory.messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageWidget(
                        message: chatMemory.messages[index],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.systemGrey5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      placeholder: '메시지를 입력하세요',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSubmitted: (text) => _sendMessage(text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _sendMessage(_textController.text),
                    child: const Icon(
                      CupertinoIcons.arrow_up_circle_fill,
                      size: 32,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 