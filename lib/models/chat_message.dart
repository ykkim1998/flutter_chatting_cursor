class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });
} 