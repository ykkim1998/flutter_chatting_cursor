import 'package:flutter/cupertino.dart';
import '../models/chat_message.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;

  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    final beginOffset = widget.message.isUser
        ? const Offset(1.0, 0.0)
        : const Offset(-1.0, 0.0);
    
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final theme = CupertinoTheme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Align(
                alignment: widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: isSmallScreen ? 8 : 16,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.message.isUser
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: size.width * (isSmallScreen ? 0.8 : 0.7),
                  ),
                  child: widget.message.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message.message,
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontFamily: 'SF Pro Text',
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedBuilder(
                              animation: _loadingController,
                              builder: (context, child) {
                                return SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CupertinoActivityIndicator(
                                    radius: 8,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Text(
                          widget.message.message,
                          style: TextStyle(
                            color: widget.message.isUser
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontFamily: 'SF Pro Text',
                            height: 1.3,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 