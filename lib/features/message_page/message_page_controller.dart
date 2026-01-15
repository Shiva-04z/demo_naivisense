

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;
import '../../models/conversation.dart';

class MessageDetailController extends GetxController {
  late String conversationId;

  var messages = <Message>[].obs;
  var participants = <UserProfile>[].obs;
  var currentUser = Rxn<UserProfile>();
  var isLoading = true.obs;
  var isSending = false.obs;
  var isOnline = false.obs;
  var isTyping = false.obs;
  var showReactionPicker = false.obs;
  var selectedMessageId = ''.obs;
  var replyToMessage = Rxn<Message>();
  var scrollController = ScrollController();

  final textController = TextEditingController();
  final focusNode = FocusNode();

  List<MessageAttachment> attachments = [];
  List<String> typingIndicators = [];

  // Emoji reactions
  final List<String> availableReactions = ['❤️', '👍', '😊', '🎉', '🤔', '😢'];

  @override
  void onInit() {
    super.onInit();

    // Get current user
    currentUser.value = DummyData.getCurrentUser();

    loadConversation();
    setupTypingSimulation();
    simulateOnlineStatus();

    // Scroll to bottom when keyboard appears
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollToBottom();
        });
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void loadConversation() {
    conversationId= glbv.selectedConversationId;
    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      final conversation = DummyData.getConversationById(conversationId);
      if (conversation != null) {
        participants.value = conversation.participants;

        // Add current user to participants list for display
        if (currentUser.value != null &&
            !participants.any((user) => user.id == 'current_user')) {
          participants.add(currentUser.value!);
        }

        final messageList = DummyData.getMessagesForConversation(conversationId);
        messages.value = messageList.messages;

        // Mark all messages as read
        markAllAsRead();

        // Add temporary "user is offline" message
        if (!isOnline.value) {
          addOfflineMessage();
        }
      }
      isLoading.value = false;
      scrollToBottom();
    });
  }

  void simulateOnlineStatus() {
    // Random online/offline simulation (70% chance online)
    isOnline.value = DateTime.now().millisecond % 10 < 7;

    // Change status every 30-60 seconds
    Future.delayed(Duration(seconds: 30 + (DateTime.now().second % 30)), () {
      simulateOnlineStatus();
    });
  }

  void setupTypingSimulation() {
    // Random typing simulation every 20-40 seconds
    Future.delayed(Duration(seconds: 20 + (DateTime.now().second % 20)), () {
      if (isOnline.value && messages.isNotEmpty) {
        simulateTyping();
      }
      setupTypingSimulation();
    });
  }

  void simulateTyping() {
    if (participants.isNotEmpty && !isTyping.value) {
      final otherParticipant = participants.firstWhereOrNull(
              (user) => user.id != 'current_user'
      );

      if (otherParticipant != null) {
        isTyping.value = true;
        typingIndicators.add(otherParticipant.id);

        // Stop typing after 1-3 seconds
        Future.delayed(Duration(seconds: 1 + (DateTime.now().second % 3)), () {
          isTyping.value = false;
          typingIndicators.remove(otherParticipant.id);
        });
      }
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < messages.length; i++) {
      if (!messages[i].isRead) {
        messages[i] = messages[i].copyWith(isRead: true);
      }
    }
    messages.refresh();
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty && attachments.isEmpty) return;

    // Check if user is offline
    if (!isOnline.value) {
      showOfflineNotification();
      return;
    }

    isSending.value = true;

    // Create temporary message
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = Message(
      id: tempId,
      conversationId: conversationId,
      senderId: 'current_user',
      senderName: 'You',
      content: text,
      timestamp: DateTime.now(),
      isRead: true,
      type: MessageType.text,
      attachments: attachments.isNotEmpty ? attachments : null,
      isSent: false,
      isDelivered: false,
      replyToMessageId: replyToMessage.value?.id,
      repliedMessage: replyToMessage.value,
      isTemporary: true,
    );

    // Add temporary message to list
    messages.add(tempMessage);
    scrollToBottom();

    // Clear input
    textController.clear();
    attachments.clear();
    replyToMessage.value = null;

    // Simulate sending delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Replace temporary message with "sent" message
    final sentMessage = tempMessage.copyWith(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      isSent: true,
      isTemporary: false,
    );

    messages[messages.indexWhere((m) => m.id == tempId)] = sentMessage;

    // Simulate delivery delay
    await Future.delayed(const Duration(milliseconds: 500));

    final deliveredMessage = sentMessage.copyWith(isDelivered: true);
    messages[messages.indexWhere((m) => m.id == sentMessage.id)] = deliveredMessage;

    // Simulate auto-reply if it's not a reply
    if (replyToMessage.value == null) {
      await Future.delayed(const Duration(seconds: 1));
      addAutoReply(text);
    }

    isSending.value = false;
    messages.refresh();
  }

  void addAutoReply(String originalMessage) {
    final replyMessages = [
      'Thanks for your message! How are you feeling today?',
      'I understand. Let\'s discuss this in our next session.',
      'That\'s a great observation. Keep up the good work!',
      'Remember to practice the techniques we discussed.',
      'I appreciate you sharing this with me.',
    ];

    final randomReply = replyMessages[DateTime.now().second % replyMessages.length];

    final otherParticipant = participants.firstWhereOrNull(
            (user) => user.id != 'current_user'
    );

    final replyMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
      conversationId: conversationId,
      senderId: otherParticipant?.id ?? participants.first.id,
      senderName: otherParticipant?.name ?? participants.first.name,
      content: randomReply,
      timestamp: DateTime.now(),
      isRead: false,
      type: MessageType.text,
      isSent: true,
      isDelivered: true,
    );

    messages.add(replyMessage);
    scrollToBottom();
  }

  void addOfflineMessage() {
    final offlineMessage = Message(
      id: 'offline_msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'system',
      content: 'The user is offline. We\'ll let them know you messaged and get back to you.',
      timestamp: DateTime.now(),
      isRead: true,
      type: MessageType.text,
      isSent: true,
      isDelivered: true, senderName: currentUser.value!.name,
    );

    messages.add(offlineMessage);
  }

  void showOfflineNotification() {
    Get.snackbar(
      'User Offline',
      'The user is offline. We\'ll let them know and get back to you.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
  // ... Rest of your controller methods remain the same ...

  // Update the call methods to use your name
  void startVideoCall() {
    if (!isOnline.value) {
      showOfflineNotification();
      return;
    }

    Get.snackbar(
      'Video Call',
      'Starting video call...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    final callMessage = Message(
      id: 'call_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'current_user',
      senderName: 'You',
      content: 'Video call started',
      timestamp: DateTime.now(),
      isRead: true,
      type: MessageType.text,
      callInfo: CallInfo(
        id: 'call_${DateTime.now().millisecondsSinceEpoch}',
        type: CallType.video,
        duration: const Duration(minutes: 0),
        startedAt: DateTime.now(),
        isMissed: false,
      ),
      isSent: true,
      isDelivered: true,
    );

    messages.add(callMessage);
    scrollToBottom();
  }

  void startAudioCall() {
    if (!isOnline.value) {
      showOfflineNotification();
      return;
    }

    Get.snackbar(
      'Audio Call',
      'Starting audio call...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    final callMessage = Message(
      id: 'call_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'current_user',
      senderName: 'You',
      content: 'Audio call started',
      timestamp: DateTime.now(),
      isRead: true,
      type: MessageType.text,
      callInfo: CallInfo(
        id: 'call_${DateTime.now().millisecondsSinceEpoch}',
        type: CallType.audio,
        duration: const Duration(minutes: 0),
        startedAt: DateTime.now(),
        isMissed: false,
      ),
      isSent: true,
      isDelivered: true,
    );

    messages.add(callMessage);
    scrollToBottom();
  }

  // Add these methods to your MessageDetailController class

  void addReaction(String messageId, String emoji) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = messages[index];
      final reaction = MessageReaction(
        emoji: emoji,
        reactedBy: ['current_user'],
      );
      messages[index] = message.copyWith(reaction: reaction);
      showReactionPicker.value = false;
    }
  }

  void removeReaction(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = messages[index];
      messages[index] = message.copyWith(reaction: null);
    }
  }

  void replyTo(Message message) {
    replyToMessage.value = message;
    focusNode.requestFocus();
  }

  void cancelReply() {
    replyToMessage.value = null;
  }

  void selectMessage(String messageId) {
    selectedMessageId.value = messageId;
  }

  void clearSelection() {
    selectedMessageId.value = '';
  }

  void deleteMessage(String messageId) {
    messages.removeWhere((m) => m.id == messageId);
    clearSelection();
  }

  void addAttachment(MessageAttachment attachment) {
    attachments.add(attachment);
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
    }
  }

  void showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.photo,
                      label: 'Photo',
                      color: Colors.blue,
                      onTap: () => _addMockAttachment('image'),
                    ),
                    _buildAttachmentOption(
                      icon: Icons.videocam,
                      label: 'Video',
                      color: Colors.purple,
                      onTap: () => _addMockAttachment('video'),
                    ),
                    _buildAttachmentOption(
                      icon: Icons.audiotrack,
                      label: 'Audio',
                      color: Colors.orange,
                      onTap: () => _addMockAttachment('audio'),
                    ),
                    _buildAttachmentOption(
                      icon: Icons.insert_drive_file,
                      label: 'File',
                      color: Colors.green,
                      onTap: () => _addMockAttachment('document'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _addMockAttachment(String type) {
    Get.back();

    final attachment = MessageAttachment(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      url: 'https://example.com/file.$type',
      type: type,
      fileName: 'attachment.${type == 'image' ? 'jpg' : type == 'video' ? 'mp4' : type == 'audio' ? 'mp3' : 'pdf'}',
      fileSize: 1024 * (1 + DateTime.now().second % 10),
    );

    addAttachment(attachment);
    Get.snackbar(
      'Attachment Added',
      '${attachment.type} attachment ready to send',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

// Add this method to refresh conversation
  void refreshConversation() {
    loadConversation();
  }

// Add this method to clear all messages (useful for testing)
  void clearAllMessages() {
    messages.clear();
    attachments.clear();
    replyToMessage.value = null;
    textController.clear();
  }

// Add this method to get conversation stats
  Map<String, int> getConversationStats() {
    final yourMessages = messages.where((m) => m.senderId == 'current_user').length;
    final theirMessages = messages.where((m) => m.senderId != 'current_user' && m.senderId != 'system').length;
    final mediaMessages = messages.where((m) => m.attachments?.isNotEmpty ?? false).length;
    final callMessages = messages.where((m) => m.callInfo != null).length;

    return {
      'yourMessages': yourMessages,
      'theirMessages': theirMessages,
      'totalMessages': messages.length,
      'mediaMessages': mediaMessages,
      'callMessages': callMessages,
    };
  }

// Add this method to simulate receiving a new message
  void simulateIncomingMessage() {
    if (participants.isEmpty) return;

    final otherParticipant = participants.firstWhereOrNull(
            (user) => user.id != 'current_user'
    );

    if (otherParticipant == null) return;

    final incomingMessages = [
      'Hello! How are you doing today?',
      'I wanted to check in about our last session.',
      'Have you been practicing the mindfulness exercises?',
      'Great progress! Keep up the good work.',
      'I\'m available for a session tomorrow if you\'re free.',
      'Remember to take care of yourself.',
      'That\'s an interesting perspective, let\'s discuss it more.',
      'I appreciate your honesty about how you\'re feeling.',
      'The progress you\'ve made is really impressive.',
      'Let me know if you need any additional support.',
    ];

    final randomMessage = incomingMessages[DateTime.now().second % incomingMessages.length];

    final newMessage = Message(
      id: 'incoming_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: otherParticipant.id,
      senderName: otherParticipant.name,
      content: randomMessage,
      timestamp: DateTime.now(),
      isRead: false,
      type: MessageType.text,
      isSent: true,
      isDelivered: true,
    );

    messages.add(newMessage);
    scrollToBottom();

    // Show notification
    Get.snackbar(
      'New Message',
      '${otherParticipant.name}: ${newMessage.content}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

// Add this method to mark a specific message as read
  void markMessageAsRead(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(isRead: true);
      messages.refresh();
    }
  }

// Add this method to edit a message
  void editMessage(String messageId, String newContent) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1 && messages[index].senderId == 'current_user') {
      messages[index] = messages[index].copyWith(
        content: newContent,
        isEdited: true,
      );
      messages.refresh();
    }
  }

// Add this method to forward a message
  void forwardMessage(String messageId, String toConversationId) {
    final message = messages.firstWhereOrNull((m) => m.id == messageId);
    if (message != null) {
      // In a real app, this would save to another conversation
      Get.snackbar(
        'Message Forwarded',
        'Message has been forwarded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    }
  }

// Add this method to save message to favorites
  void toggleFavorite(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final isCurrentlyFavorite = messages[index].isFavorite ?? false;
      messages[index] = messages[index].copyWith(
        isFavorite: !isCurrentlyFavorite,
      );
      messages.refresh();

      Get.snackbar(
        isCurrentlyFavorite ? 'Removed from Favorites' : 'Added to Favorites',
        isCurrentlyFavorite
            ? 'Message removed from favorites'
            : 'Message added to favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isCurrentlyFavorite ? Colors.grey : Colors.amber,
        colorText: Colors.white,
      );
    }
  }

// Add this method to copy message to clipboard
  void copyMessageToClipboard(String messageId) {
    final message = messages.firstWhereOrNull((m) => m.id == messageId);
    if (message != null) {
      // In a real app, this would use Clipboard.setData
      Get.snackbar(
        'Copied',
        'Message copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    }
  }

// Add this method to pin/unpin a message
  void togglePinMessage(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final isCurrentlyPinned = messages[index].isPinned ?? false;
      messages[index] = messages[index].copyWith(
        isPinned: !isCurrentlyPinned,
      );
      messages.refresh();

      Get.snackbar(
        isCurrentlyPinned ? 'Unpinned' : 'Pinned',
        isCurrentlyPinned
            ? 'Message unpinned'
            : 'Message pinned to conversation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isCurrentlyPinned ? Colors.grey : Colors.blue,
        colorText: Colors.white,
      );
    }
  }

// Add this method to report a message
  void reportMessage(String messageId, String reason) {
    Get.snackbar(
      'Message Reported',
      'Thank you for reporting this message. We will review it shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

// Add this method to get pinned messages
  List<Message> getPinnedMessages() {
    return messages.where((m) => m.isPinned == true).toList();
  }

// Add this method to get favorite messages
  List<Message> getFavoriteMessages() {
    return messages.where((m) => m.isFavorite == true).toList();
  }

// Add this method to get unread messages count
  int getUnreadMessagesCount() {
    return messages.where((m) => !m.isRead && m.senderId != 'current_user').length;
  }

// Add this method to search within messages
  List<Message> searchInMessages(String query) {
    if (query.isEmpty) return [];

    return messages.where((message) {
      return message.content.toLowerCase().contains(query.toLowerCase()) ||
          (message.senderName?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

// Add this method to export conversation
  void exportConversation() {
    Get.snackbar(
      'Export Started',
      'Your conversation is being exported. You will receive a notification when it\'s ready.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

// Add this method to clear chat history
  void clearChatHistory() {
    Get.defaultDialog(
      title: 'Clear Chat History',
      content: const Text('Are you sure you want to clear all messages in this conversation? This action cannot be undone.'),
      textConfirm: 'Clear',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        messages.clear();
        Get.back();
        Get.snackbar(
          'Chat Cleared',
          'All messages have been cleared from this conversation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
        );
      },
    );
  }

// Add this method to mute/unmute notifications
  void toggleMuteNotifications() {
    final isMuted = false; // This would be stored in preferences
    Get.snackbar(
      isMuted ? 'Notifications Unmuted' : 'Notifications Muted',
      isMuted
          ? 'You will receive notifications for new messages'
          : 'You will not receive notifications for new messages',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isMuted ? Colors.teal : Colors.grey,
      colorText: Colors.white,
    );
  }

// Add this method to share conversation
  void shareConversation() {
    Get.snackbar(
      'Share Conversation',
      'Conversation sharing options would appear here',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }
}