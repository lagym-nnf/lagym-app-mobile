import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';

/// Chat message model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

/// Mock AI responses
final _aiResponses = {
  'hello': "Hello! I'm your LA GYM fitness assistant. How can I help you today?",
  'workout': "I'd recommend starting with a full-body strength workout today! You can find great options in the Workouts section. Would you like some specific exercises?",
  'nutrition': "For optimal results, focus on protein-rich meals after workouts. Aim for 1.6-2.2g of protein per kg of body weight daily. Check out our Nutrition section for healthy recipes!",
  'motivation': "Remember: Every workout brings you one step closer to your goals. You've already shown commitment by being here. Let's crush it today!",
  'sore': "Muscle soreness is normal! Try light stretching, foam rolling, or a gentle yoga session. Stay hydrated and get enough sleep for recovery.",
  'weight': "Weight loss is 80% diet and 20% exercise. Focus on a slight calorie deficit, plenty of protein, and consistent workouts. Track your progress in the Progress section!",
  'default': "I'm here to help with your fitness journey! Feel free to ask me about workouts, nutrition, motivation, or any fitness-related questions.",
};

String _getAIResponse(String message) {
  final lower = message.toLowerCase();

  if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
    return _aiResponses['hello']!;
  }
  if (lower.contains('workout') || lower.contains('exercise') || lower.contains('training')) {
    return _aiResponses['workout']!;
  }
  if (lower.contains('nutrition') || lower.contains('food') || lower.contains('diet') || lower.contains('eat')) {
    return _aiResponses['nutrition']!;
  }
  if (lower.contains('motivation') || lower.contains('tired') || lower.contains('give up')) {
    return _aiResponses['motivation']!;
  }
  if (lower.contains('sore') || lower.contains('pain') || lower.contains('recovery')) {
    return _aiResponses['sore']!;
  }
  if (lower.contains('weight') || lower.contains('lose') || lower.contains('fat')) {
    return _aiResponses['weight']!;
  }

  return _aiResponses['default']!;
}

/// Chat messages provider
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([
    ChatMessage(
      id: '0',
      content: "Hi there! I'm your LA GYM AI assistant. I can help you with workout recommendations, nutrition advice, motivation, and fitness questions. What would you like to know?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ]);

  void addMessage(String content, bool isUser) {
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: isUser,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String content) async {
    // Add user message
    addMessage(content, true);

    // Simulate AI thinking
    await Future.delayed(const Duration(milliseconds: 800));

    // Add AI response
    final response = _getAIResponse(content);
    addMessage(response, false);
  }
}

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() => _isTyping = true);

    await ref.read(chatMessagesProvider.notifier).sendMessage(text);

    setState(() => _isTyping = false);

    // Scroll to bottom after message is added
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.pinkDark, AppColors.coral],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(PhosphorIcons.robot(), size: 24, color: AppColors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LA GYM Assistant', style: AppTypography.cardTitle),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.mintDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Online',
                              style: AppTypography.captionSmall.copyWith(color: AppColors.mintDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick action chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _QuickActionChip(
                    label: 'Workout tips',
                    onTap: () => _sendQuickAction('Can you give me some workout tips?'),
                  ),
                  _QuickActionChip(
                    label: 'Nutrition advice',
                    onTap: () => _sendQuickAction('What should I eat for better results?'),
                  ),
                  _QuickActionChip(
                    label: 'Motivation',
                    onTap: () => _sendQuickAction('I need some motivation today'),
                  ),
                  _QuickActionChip(
                    label: 'Recovery help',
                    onTap: () => _sendQuickAction('My muscles are sore, what should I do?'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                itemCount: messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == messages.length) {
                    return _TypingIndicator();
                  }
                  return _ChatBubble(message: messages[index]);
                },
              ),
            ),

            // Input area
            Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about fitness...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
                        filled: true,
                        fillColor: AppColors.gray50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.pinkDark, AppColors.coral],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill), color: AppColors.white, size: 22),
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

  void _sendQuickAction(String message) {
    _textController.text = message;
    _sendMessage();
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: AppColors.pinkDark.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.pinkDark),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: message.isUser ? 60 : 0,
          right: message.isUser ? 0 : 60,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.pinkDark, AppColors.coral],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(PhosphorIcons.robot(), size: 16, color: AppColors.white),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: message.isUser ? AppColors.pinkDark : AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 16),
                  ),
                  boxShadow: message.isUser ? null : AppShadows.sm,
                ),
                child: Text(
                  message.content,
                  style: AppTypography.bodyMedium.copyWith(
                    color: message.isUser ? AppColors.white : AppColors.gray900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, right: 60),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.pinkDark, AppColors.coral],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(PhosphorIcons.robot(), size: 16, color: AppColors.white),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: AppShadows.sm,
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final delay = index * 0.2;
                      final progress = (_controller.value + delay) % 1.0;
                      final opacity = (1 - (progress * 2 - 1).abs()).clamp(0.3, 1.0);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.pinkDark.withValues(alpha: opacity),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
