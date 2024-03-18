import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _handleUserInput(String text) {
    setState(() {
      _messages.insert(0, {'text': text, 'sender': 'user'});
      _messages.insert(
          0, {'text': '안녕하세요, 당신을 도와줄 챗봇입니다. 무엇을 도와드릴까요?', 'sender': 'bot'});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool isUserMessage = message['sender'] == 'user';
                  final bool isFirstMessage = index == 0 ||
                      _messages[index - 1]['sender'] != message['sender'];

                  // 챗봇에서 오는 메시지인 경우에만 왼쪽 하단 모서리를 조절합니다.
                  final BorderRadius messageBorderRadius = isUserMessage
                      ? BorderRadius.only(
                          topLeft: isFirstMessage
                              ? const Radius.circular(20.0)
                              : const Radius.circular(4.0),
                          topRight: isFirstMessage
                              ? const Radius.circular(20.0)
                              : const Radius.circular(4.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          topLeft: isFirstMessage
                              ? const Radius.circular(20.0)
                              : const Radius.circular(4.0),
                          topRight: isFirstMessage
                              ? const Radius.circular(20.0)
                              : const Radius.circular(4.0),
                          bottomLeft: const Radius.circular(4.0),
                          bottomRight: const Radius.circular(20.0),
                        );

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: isUserMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isUserMessage)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0, top: 5.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/bot_image.png'),
                              radius: 25,
                            ),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Colors.blue[100]
                                  : Colors.grey[300],
                              borderRadius: messageBorderRadius,
                            ),
                            child: Text(
                              message['text'] ?? '',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '메시지를 입력하세요...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) => _handleUserInput(text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        _handleUserInput(_controller.text);
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(Icons.send, color: Colors.white),
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
