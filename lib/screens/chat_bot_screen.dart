import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _addBotGreeting();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotGreeting() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(ChatMessage(
          text: "👋 Hi! I'm your assistant. Choose an option:",
          isUser: false,
          showFeatures: true,
        ));
      });
      _scrollToBottom();
    });
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

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _textController.clear();
    });
    _scrollToBottom();

    // Simulate bot response
    _simulateBotResponse();
  }

  void _onFeatureSelected(String feature) {
    setState(() {
      _messages.add(ChatMessage(text: feature, isUser: true));
    });
    _scrollToBottom();
    _simulateBotResponse();
  }

  void _simulateBotResponse() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: "I've received your request for the selected feature. Processing...",
          isUser: false,
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // AppBar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade300.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.smart_toy, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Assistant',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.light_mode, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            // Chat Messages
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.white],
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _messages.length) {
                      final message = _messages[index];
                      return Column(
                        children: [
                          ChatBubble(
                            message: message.text,
                            isUser: message.isUser,
                            animationController: _animationController,
                            delay: Duration(milliseconds: 100 * index),
                          ),
                          if (message.showFeatures) ...[
                            const SizedBox(height: 16),
                            FeatureCards(onFeatureSelected: _onFeatureSelected),
                          ],
                        ],
                      );
                    } else {
                      return const TypingIndicator();
                    }
                  },
                ),
              ),
            ),

            // Input Bar
            MessageInputBar(
              controller: _textController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool showFeatures;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.showFeatures = false,
  });
}

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isUser;
  final AnimationController animationController;
  final Duration delay;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.animationController,
    required this.delay,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isUser ? 1.0 : -1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        widget.animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isUser)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.cyan.shade400],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isUser
                          ? [Colors.green.shade500, Colors.lime.shade400]
                          : [Colors.teal.shade500, Colors.cyan.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.isUser ? 20 : 4),
                      topRight: Radius.circular(widget.isUser ? 4 : 20),
                      bottomLeft: const Radius.circular(20),
                      bottomRight: const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (widget.isUser)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade500, Colors.lime.shade400],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCards extends StatelessWidget {
  final Function(String) onFeatureSelected;

  const FeatureCards({super.key, required this.onFeatureSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFeatureCard(
          title: 'Water Levels',
          icon: Icons.water_drop,
          color: Colors.blue,
          gradient: [Colors.blue.shade500, Colors.blue.shade300],
          onTap: () => onFeatureSelected('Water Levels'),
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          title: 'Rainfall Forecast',
          icon: Icons.cloudy_snowing,
          color: Colors.purple,
          gradient: [Colors.purple.shade500, Colors.purple.shade300],
          onTap: () => onFeatureSelected('Rainfall Forecast'),
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          title: 'Historical Data',
          icon: Icons.bar_chart,
          color: Colors.orange,
          gradient: [Colors.orange.shade500, Colors.orange.shade300],
          onTap: () => onFeatureSelected('Historical Data'),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          tween: Tween(begin: 1.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    if (_hasText) {
      widget.onSend(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey.shade500),
                    onPressed: () {},
                  ),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Voice Button
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade500, Colors.pink.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.mic, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          // Send Button
          FloatingActionButton(
            onPressed: _handleSend,
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _hasText
                      ? [Colors.blue.shade500, Colors.cyan.shade400]
                      : [Colors.grey.shade400, Colors.grey.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: _hasText
                    ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.2 * index, 0.2 * index + 0.6, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.cyan.shade400],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade500, Colors.cyan.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _dotAnimations[index],
                  builder: (context, child) {
                    return Opacity(
                      opacity: _dotAnimations[index].value,
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}