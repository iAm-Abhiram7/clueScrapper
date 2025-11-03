import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/services/hive_service.dart';
import '../../../chat/data/models/chat_model.dart';

/// Chat history screen showing all previous chat sessions with enhanced UI
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'date'; // 'date' or 'images'
  bool _showArchived = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        title: const Text('Chat History'),
        backgroundColor: appColors.background,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort & Filter',
            onSelected: (value) {
              setState(() {
                if (value == 'archive') {
                  _showArchived = !_showArchived;
                } else {
                  _sortBy = value;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: _sortBy == 'date' ? appColors.indigoInk : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sort by Date',
                      style: TextStyle(
                        color: _sortBy == 'date' ? appColors.indigoInk : null,
                        fontWeight: _sortBy == 'date' ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'images',
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      size: 20,
                      color: _sortBy == 'images' ? appColors.indigoInk : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sort by Images',
                      style: TextStyle(
                        color: _sortBy == 'images' ? appColors.indigoInk : null,
                        fontWeight: _sortBy == 'images'
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(
                      _showArchived
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                      color: _showArchived ? appColors.indigoInk : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Show Archived'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by case ID or date...',
                prefixIcon: Icon(Icons.search, color: appColors.graphite),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: appColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Chat List
          Expanded(
            child: FutureBuilder<List<ChatModel>>(
              future: _loadChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator(message: 'Loading chats...');
                }

                if (snapshot.hasError) {
                  return _buildErrorState(appColors, snapshot.error.toString());
                }

                final chats = snapshot.data ?? [];
                final filteredChats = _filterAndSortChats(chats);

                if (filteredChats.isEmpty && _searchQuery.isEmpty) {
                  return _buildEmptyState(appColors);
                }

                if (filteredChats.isEmpty && _searchQuery.isNotEmpty) {
                  return _buildNoResultsState(appColors);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {}); // Trigger rebuild
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      return ChatHistoryCard(
                        key: ValueKey(chat.chatId),
                        chat: chat,
                        onTap: () => _openChat(chat.chatId),
                        onDelete: () => _deleteChat(chat.chatId),
                        onArchive: () => _archiveChat(chat.chatId),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ChatModel>> _loadChats() async {
    try {
      final hiveService = HiveService();
      final chatBox = hiveService.chatBox;
      return chatBox.values.toList();
    } catch (e) {
      debugPrint('Error loading chats: $e');
      rethrow;
    }
  }

  List<ChatModel> _filterAndSortChats(List<ChatModel> chats) {
    // Filter by archived status
    var filtered = chats.where((chat) {
      if (_showArchived) return true;
      return chat.status != 'archived';
    }).toList();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((chat) {
        final caseId = chat.chatId.toLowerCase();
        final dateStr = DateFormatter.formatDate(chat.createdAt).toLowerCase();
        return caseId.contains(_searchQuery) || dateStr.contains(_searchQuery);
      }).toList();
    }

    // Sort
    if (_sortBy == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'images') {
      filtered.sort((a, b) => b.imageCount.compareTo(a.imageCount));
    }

    return filtered;
  }

  Widget _buildEmptyState(AppColors appColors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: appColors.mutedSand.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: appColors.mutedSand,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Conversations Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appColors.darkCharcoal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start analyzing crime scene images to create your first forensic report',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: appColors.graphite),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Switch to New tab
                DefaultTabController.of(context).animateTo(1);
              },
              icon: const Icon(Icons.add),
              label: const Text('Start New Analysis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.indigoInk,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(AppColors appColors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: appColors.mutedSand),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: appColors.darkCharcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(fontSize: 16, color: appColors.graphite),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppColors appColors, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: appColors.error),
            const SizedBox(height: 16),
            Text(
              'Error Loading Chats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: appColors.darkCharcoal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: appColors.error),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(String chatId) {
    context.go('/chat/$chatId');
  }

  Future<void> _deleteChat(String chatId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final appColors = context.appColors;
        return AlertDialog(
          title: Text(
            'Delete Chat',
            style: TextStyle(color: appColors.darkCharcoal),
          ),
          content: const Text(
            'Are you sure you want to delete this chat? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final hiveService = HiveService();
        final chatBox = hiveService.chatBox;
        final messageBox = hiveService.messageBox;

        // Delete all messages for this chat
        final messagesToDelete = messageBox.values
            .where((msg) => msg.chatId == chatId)
            .map((msg) => msg.messageId)
            .toList();

        for (final msgId in messagesToDelete) {
          await messageBox.delete(msgId);
        }

        // Delete all images for this chat
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final chatDir = Directory('${appDir.path}/chats/$chatId');

          if (await chatDir.exists()) {
            await chatDir.delete(recursive: true);
            debugPrint('Deleted all images for chat $chatId');
          }
        } catch (e) {
          debugPrint('Error deleting chat images: $e');
          // Continue with deletion even if images fail
        }

        // Finally, delete the chat itself
        await chatBox.delete(chatId);

        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chat deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _archiveChat(String chatId) async {
    try {
      final hiveService = HiveService();
      final chatBox = hiveService.chatBox;
      final chat = chatBox.get(chatId);

      if (chat != null) {
        final updatedChat = chat.copyWith(
          status: chat.status == 'archived' ? 'active' : 'archived',
        );
        await chatBox.put(chatId, updatedChat);
        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                chat.status == 'archived' ? 'Chat unarchived' : 'Chat archived',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

/// Enhanced chat history card
class ChatHistoryCard extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onArchive;

  const ChatHistoryCard({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onDelete,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return FutureBuilder<ChatSummary>(
      future: _loadChatSummary(),
      builder: (context, snapshot) {
        final summary = snapshot.data;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: chat.status == 'archived'
                  ? appColors.graphite.withOpacity(0.2)
                  : appColors.lightSage,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: appColors.darkCharcoal.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              onLongPress: () => _showOptions(context, appColors),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: appColors.indigoInk.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.folder_open,
                                  color: appColors.indigoInk,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Case #${chat.chatId}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.darkCharcoal,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: appColors.graphite.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormatter.formatChatTimestamp(
                                            chat.createdAt,
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: appColors.graphite
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(appColors),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Image Preview
                    if (chat.imagePaths.isNotEmpty)
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: chat.imagePaths.length > 4
                              ? 4
                              : chat.imagePaths.length,
                          itemBuilder: (context, index) {
                            if (index == 3 && chat.imagePaths.length > 4) {
                              return _buildMoreImagesIndicator(appColors);
                            }
                            return _buildImageThumbnail(
                              chat.imagePaths[index],
                              appColors,
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),
                    Divider(
                      color: appColors.lightSage.withOpacity(0.3),
                      height: 1,
                    ),
                    const SizedBox(height: 12),

                    // Info chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(
                          icon: Icons.image,
                          label: '${chat.imageCount} images',
                          appColors: appColors,
                        ),
                        if (summary != null) ...[
                          _buildInfoChip(
                            icon: Icons.chat_bubble_outline,
                            label: '${summary.messageCount} messages',
                            appColors: appColors,
                          ),
                          if (summary.evidenceCount > 0)
                            _buildInfoChip(
                              icon: Icons.verified_outlined,
                              label: '${summary.evidenceCount} evidence',
                              appColors: appColors,
                              color: appColors.indigoInk,
                            ),
                        ],
                      ],
                    ),

                    // Last message preview
                    if (summary?.lastMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        summary!.lastMessage!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.graphite.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(AppColors appColors) {
    final isArchived = chat.status == 'archived';
    final color = isArchived ? appColors.graphite : const Color(0xFF4CAF50);
    final icon = isArchived ? Icons.archive : Icons.circle;
    final label = isArchived ? 'Archived' : 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath, AppColors appColors) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appColors.lightSage, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: appColors.mutedSand.withOpacity(0.3),
            child: Icon(
              Icons.broken_image,
              color: appColors.graphite,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreImagesIndicator(AppColors appColors) {
    final remaining = chat.imagePaths.length - 3;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: appColors.indigoInk.withOpacity(0.1),
        border: Border.all(color: appColors.indigoInk, width: 1),
      ),
      child: Center(
        child: Text(
          '+$remaining',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appColors.indigoInk,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required AppColors appColors,
    Color? color,
  }) {
    final chipColor = color ?? appColors.graphite;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, AppColors appColors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: appColors.graphite.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Case #${chat.chatId}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: appColors.darkCharcoal,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.open_in_new, color: appColors.indigoInk),
              title: const Text('Open Chat'),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            ListTile(
              leading: Icon(
                chat.status == 'archived' ? Icons.unarchive : Icons.archive,
                color: appColors.graphite,
              ),
              title: Text(chat.status == 'archived' ? 'Unarchive' : 'Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Chat',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<ChatSummary> _loadChatSummary() async {
    try {
      final hiveService = HiveService();
      final messageBox = hiveService.messageBox;

      final messages = messageBox.values
          .where((msg) => msg.chatId == chat.chatId)
          .toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      String? lastMessage;
      if (messages.isNotEmpty) {
        final lastMsg = messages.last;
        final content = lastMsg.content;
        final preview = content.length > 60
            ? '${content.substring(0, 60)}...'
            : content;
        lastMessage = lastMsg.isUser ? 'You: $preview' : preview;
      }

      int evidenceCount = 0;
      for (final msg in messages) {
        if (msg.evidenceData != null && msg.evidenceData!.isNotEmpty) {
          evidenceCount++;
        }
      }

      return ChatSummary(
        messageCount: messages.length,
        evidenceCount: evidenceCount,
        lastMessage: lastMessage,
      );
    } catch (e) {
      return ChatSummary(messageCount: 0, evidenceCount: 0);
    }
  }
}

class ChatSummary {
  final int messageCount;
  final int evidenceCount;
  final String? lastMessage;

  ChatSummary({
    required this.messageCount,
    required this.evidenceCount,
    this.lastMessage,
  });
}
