import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _messages.add(
      ChatMessage(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    _messages.add(
      ChatMessage(
        message: "AI가 응답을 생성하고 있습니다...",
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: true,
      ),
    );
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      final loadingIndex = _messages.length - 1;
      if (loadingIndex >= 0 && _messages[loadingIndex].isLoading) {
        _messages[loadingIndex] = ChatMessage(
          message: "이것은 AI의 임시 응답 메시지입니다. 실제 AI 응답 기능은 구현되지 않았습니다.",
          isUser: false,
          timestamp: DateTime.now(),
        );
        notifyListeners();
      }
    });
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
} 