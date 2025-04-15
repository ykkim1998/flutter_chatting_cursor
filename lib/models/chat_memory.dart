import 'package:flutter/foundation.dart';
import 'chat_message.dart';

class ChatMemory extends ChangeNotifier {
  static const int maxMessages = 10;
  final List<ChatMessage> _messages = [];
  
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  
  void addMessage(String text, bool isUser) {
    if (_messages.length >= maxMessages) {
      _messages.removeAt(0); // FIFO 방식으로 가장 오래된 메시지 제거
    }
    
    _messages.add(ChatMessage(
      message: text,
      isUser: isUser,
      timestamp: DateTime.now(),
      isLoading: false,
    ));
    
    if (kDebugMode) {
      print('메시지 추가됨: ${isUser ? "사용자" : "AI"} - $text');
      print('현재 메시지 목록:');
      for (var msg in _messages) {
        print('${msg.isUser ? "사용자" : "AI"}: ${msg.message}');
      }
    }
    
    notifyListeners();
  }
  
  void clear() {
    _messages.clear();
    notifyListeners();
  }
} 