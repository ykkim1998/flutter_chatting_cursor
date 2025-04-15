import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_message_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
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
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'AI Chat',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageWidget(
                    message: viewModel.messages[index],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomPadding),
              decoration: BoxDecoration(
                color: theme.barBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.systemGrey4,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      placeholder: '메시지를 입력하세요...',
                      placeholderStyle: TextStyle(
                        color: theme.textTheme.textStyle.color?.withOpacity(0.5),
                        fontFamily: 'SF Pro Text',
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.barBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CupertinoColors.systemGrey4,
                          width: 0.5,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        color: theme.textTheme.textStyle.color,
                      ),
                      onSubmitted: (_) => _sendMessage(viewModel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    onPressed: () => _sendMessage(viewModel),
                    padding: const EdgeInsets.all(12),
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

  void _sendMessage(ChatViewModel viewModel) {
    if (_textController.text.trim().isNotEmpty) {
      viewModel.sendMessage(_textController.text);
      _textController.clear();
      _scrollToBottom();
    }
  }
} 