import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/router/app_router.dart';
import '../providers/chat_provider.dart';
import '../widgets/user_message_bubble.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/image_gallery_header.dart';

/// Chat detail screen with messages, images, and input
class ChatDetailScreen extends StatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChat();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChat() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadChat(widget.chatId);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
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
  }

  void _handleSend(String message) {
    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(message);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final chatProvider = context.watch<ChatProvider>();

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to home screen with chat history tab selected
        context.go(AppRouter.home);
        return false; // Prevent default pop behavior
      },
      child: Scaffold(
        backgroundColor: appColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to home screen
              context.go(AppRouter.home);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Case #${widget.chatId}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Active Analysis',
                style: TextStyle(
                  fontSize: 12,
                  color: appColors.graphite,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'archive':
                  // TODO: Implement archive
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Archive feature coming soon'),
                    ),
                  );
                  break;
                case 'report':
                  // TODO: Navigate to report generation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report generation coming in Phase 5'),
                    ),
                  );
                  break;
                case 'delete':
                  final confirm = await _showDeleteDialog();
                  if (confirm == true && context.mounted) {
                    await chatProvider.deleteChat(widget.chatId);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined),
                    SizedBox(width: 12),
                    Text('Archive'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.description_outlined),
                    SizedBox(width: 12),
                    Text('Generate Report'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Image gallery header
          if (chatProvider.hasImages)
            ImageGalleryHeader(imagePaths: chatProvider.imagePaths),

          // Messages list
          Expanded(
            child: chatProvider.isLoading && chatProvider.messages.isEmpty
                ? _buildLoadingState(appColors)
                : chatProvider.error != null && chatProvider.messages.isEmpty
                ? _buildErrorState(appColors, chatProvider.error!)
                : _buildMessagesList(chatProvider),
          ),

          // Chat input
          ChatInputField(
            onSend: _handleSend,
            isEnabled: !chatProvider.isLoading,
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMessagesList(ChatProvider chatProvider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end
        if (index == chatProvider.messages.length) {
          return const TypingIndicator();
        }

        final message = chatProvider.messages[index];

        if (message.isUser) {
          return UserMessageBubble(message: message);
        } else {
          // Find evidence for this message
          final evidence = chatProvider.evidenceList;
          return AIMessageBubble(message: message, evidence: evidence);
        }
      },
    );
  }

  Widget _buildLoadingState(AppColors appColors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: appColors.indigoInk),
          const SizedBox(height: 16),
          Text(
            'Loading chat...',
            style: TextStyle(color: appColors.graphite, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppColors appColors, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: appColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.darkCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: appColors.graphite),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadChat,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.indigoInk,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        final appColors = context.appColors;
        return AlertDialog(
          title: const Text('Delete Chat'),
          content: const Text(
            'Are you sure you want to delete this chat? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: appColors.error),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
