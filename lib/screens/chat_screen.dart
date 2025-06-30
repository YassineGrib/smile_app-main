import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String? text;
  final String? imagePath;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    this.text,
    this.imagePath,
    required this.isUser,
    required this.timestamp,
  }) : assert(text != null || imagePath != null);

  bool get isLocalImage => imagePath != null && !(imagePath!.startsWith('http') || imagePath!.startsWith('https'));
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Add welcome message
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessage(ChatMessage(
        text: 'Hello! Welcome to SMILE Kindergarten. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    _addMessage(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    _messageController.clear();

    // Simulate admin typing
    setState(() {
      _isTyping = true;
    });

    // Simulate admin response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
      });
      
      _addMessage(ChatMessage(
        text: _getAutoResponse(text),
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  String _getAutoResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('price') || message.contains('cost') || message.contains('fee')) {
      return 'Our pricing is:\n• Basic Plan: ${AppConstants.basicPlanPrice} DA/month\n• Premium Plan: ${AppConstants.premiumPlanPrice} DA/month\n\nWould you like to know more about what\'s included in each plan?';
    } else if (message.contains('hours') || message.contains('time') || message.contains('schedule')) {
      return 'We offer flexible schedules:\n• Morning: 7:00 AM - 12:00 PM\n• Evening: 1:00 PM - 6:00 PM\n• Full Day: 7:00 AM - 6:00 PM\n\nWhich schedule works best for your family?';
    } else if (message.contains('age') || message.contains('old')) {
      return 'We accept children from 6 months to 5 years old. Our programs are designed for different age groups to ensure appropriate care and activities for each child.';
    } else if (message.contains('visit') || message.contains('tour')) {
      return 'We\'d love to show you our facilities! You can book a visit through our app or call us directly. Would you like me to help you schedule a visit?';
    } else if (message.contains('food') || message.contains('meal') || message.contains('lunch')) {
      return 'We provide nutritious meals:\n• Basic Plan: Lunch included\n• Premium Plan: 3 meals (breakfast, lunch, snack)\n\nAll meals are prepared fresh daily with healthy, child-friendly ingredients.';
    } else if (message.contains('safety') || message.contains('security')) {
      return 'Safety is our top priority! We have:\n• 24/7 security cameras\n• Trained staff with first aid certification\n• Secure entry/exit system\n• Regular safety drills\n• Child-proofed environment';
    } else if (message.contains('staff') || message.contains('teacher')) {
      return 'Our staff are highly qualified:\n• Licensed early childhood educators\n• First aid and CPR certified\n• Background checked\n• Ongoing professional development\n• Low child-to-staff ratios for personalized care';
    } else {
      return 'Thank you for your message! Our team will get back to you shortly. In the meantime, feel free to ask about our programs, pricing, schedules, or anything else you\'d like to know about ${AppConstants.nurseryName}.';
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _addMessage(
        ChatMessage(
          imagePath: image.path,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppConstants.nurseryName} Support',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online now',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.textLightColor.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_camera, color: AppTheme.primaryColor),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppBorderRadius.round),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: message.isUser ? AppTheme.primaryColor : AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg).copyWith(
                  topLeft: message.isUser ? const Radius.circular(AppBorderRadius.lg) : const Radius.circular(0),
                  topRight: message.isUser ? const Radius.circular(0) : const Radius.circular(AppBorderRadius.lg),
                ),
              ),
              child: message.text != null
                  ? Text(
                      message.text!,
                      style: TextStyle(
                        color: message.isUser ? AppTheme.chatTextUser : AppTheme.chatTextAdmin,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      child: message.isLocalImage
                          ? Image.file(
                              File(message.imagePath!),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              message.imagePath!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.secondaryColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg).copyWith(
                bottomLeft: Radius.zero,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -4 * (0.5 - (value - index * 0.2).abs()).clamp(0.0, 0.5)),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
