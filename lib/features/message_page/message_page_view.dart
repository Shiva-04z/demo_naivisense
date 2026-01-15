import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

import '../../models/conversation.dart';
import 'message_page_controller.dart';

class MessageDetailView extends GetView<MessageDetailController> {
  const MessageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),

            // Messages List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingShimmer();
                }
                return _buildMessagesList();
              }),
            ),

            // Reply Preview (if any)
            Obx(() => controller.replyToMessage.value != null
                ? _buildReplyPreview()
                : const SizedBox.shrink()),

            // Input Area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Obx(() {
      final otherParticipant = controller.participants.firstWhereOrNull(
            (user) => user.id != 'current_user',
      );

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey[700],
                size: 24,
              ),
            ),

            // User avatar
            if (otherParticipant != null)
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal[200]!, Colors.teal[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    otherParticipant.name.split(' ').map((n) => n[0]).join(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (otherParticipant != null)
                    Text(
                      otherParticipant.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Obx(() => Row(
                    children: [
                      // Online status
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: controller.isOnline.value
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        controller.isOnline.value ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.isOnline.value
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Typing indicator
                      if (controller.isTyping.value) ...[
                        const SizedBox(width: 8),
                        Text(
                          'typing...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  )),
                ],
              ),
            ),

            // Call buttons
            Row(
              children: [
                // Audio call
                IconButton(
                  onPressed: controller.startAudioCall,
                  icon: Icon(
                    Icons.phone_outlined,
                    color: Colors.grey[700],
                    size: 22,
                  ),
                  tooltip: 'Audio Call',
                ),
                // Video call
                IconButton(
                  onPressed: controller.startVideoCall,
                  icon: Icon(
                    Icons.videocam_outlined,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                  tooltip: 'Video Call',
                ),
                // More options
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text('Conversation Info'),
                        ],
                      ),
                      onTap: () => _showConversationInfo(),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text('Mute Notifications'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.block, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          const Text('Block User'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMessagesList() {
    return GestureDetector(
      onTap: () {
        controller.clearSelection();
        controller.focusNode.unfocus();
      },
      child: Stack(
        children: [
          ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              final message = controller.messages[index];
              return _buildMessageBubble(message, index);
            },
          ),
          // Reaction picker overlay
          Obx(() => controller.showReactionPicker.value
              ? Positioned.fill(
            child: GestureDetector(
              onTap: () => controller.showReactionPicker.value = false,
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: Center(child: _buildReactionPicker()),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, int index) {
    final isCurrentUser = message.senderId == 'current_user';
    final isSystem = message.senderId == 'system';

    // Check if we should show sender name
    bool showSenderName = false;
    if (!isCurrentUser && !isSystem) {
      if (index == 0) {
        showSenderName = true;
      } else {
        final prevMessage = controller.messages[index - 1];
        final timeDiff = message.timestamp
            .difference(prevMessage.timestamp)
            .inMinutes;
        showSenderName = prevMessage.senderId != message.senderId ||
            timeDiff > 5 ||
            prevMessage.callInfo != null ||
            message.callInfo != null;
      }
    }

    // For temporary messages, show sending indicator
    if (message.isTemporary) {
      return _buildSendingMessage(message);
    }

    // For system messages (like offline notification)
    if (isSystem) {
      return _buildSystemMessage(message);
    }

    // For call messages
    if (message.callInfo != null) {
      return _buildCallMessage(message);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Show sender name for non-current user
          if (showSenderName)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.senderName!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          // Show replied message if exists
          if (message.repliedMessage != null)
            _buildReplyPreviewInMessage(message.repliedMessage!, isCurrentUser),
          // Message bubble
          GestureDetector(
            onLongPress: () => _showMessageOptions(message),
            onTap: () => controller.selectMessage(message.id),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(Get.context!).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.teal : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: !isCurrentUser
                    ? Border.all(color: Colors.grey[200]!, width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attachments
                  if (message.attachments != null &&
                      message.attachments!.isNotEmpty)
                    ...message.attachments!
                        .map((attachment) =>
                        _buildAttachment(attachment, isCurrentUser))
                        .toList(),
                  // Message text
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        color: isCurrentUser ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  // Timestamp and status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrentUser
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[500],
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isDelivered
                              ? Icons.done_all
                              : message.isSent
                              ? Icons.done
                              : Icons.access_time,
                          size: 14,
                          color: message.isDelivered
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                  // Reaction
                  if (message.reaction != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${message.reaction!.emoji} ${message.reaction!.reactedBy.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Selected message overlay
          Obx(() => controller.selectedMessageId.value == message.id
              ? _buildSelectedMessageOverlay(message)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildSendingMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  message.content,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange[600],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange[800],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallMessage(Message message) {
    final isVideoCall = message.callInfo?.type == CallType.video;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isVideoCall ? Icons.videocam : Icons.phone,
              color: Colors.teal,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVideoCall ? 'Video Call' : 'Audio Call',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Tap to join call',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (!controller.isOnline.value) {
                controller.showOfflineNotification();
                return;
              }
              Get.snackbar(
                'Joining Call',
                'Connecting to ${isVideoCall ? 'video' : 'audio'} call...',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: Icon(
              Icons.call,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(MessageAttachment attachment, bool isCurrentUser) {
    Widget attachmentWidget;

    switch (attachment.type) {
      case 'image':
        attachmentWidget = Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
            image: DecorationImage(
              image: NetworkImage(attachment.thumbnailUrl ?? attachment.url),
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      case 'video':
        attachmentWidget = Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (attachment.thumbnailUrl != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(attachment.thumbnailUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.teal,
                  size: 24,
                ),
              ),
            ],
          ),
        );
        break;
      default:
        attachmentWidget = Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                _getAttachmentIcon(attachment.type),
                color: Colors.grey[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.fileName ?? 'Attachment',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (attachment.fileSize != null)
                      Text(
                        '${(attachment.fileSize! / 1024).toStringAsFixed(1)} KB',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: attachmentWidget,
    );
  }

  IconData _getAttachmentIcon(String type) {
    switch (type) {
      case 'image':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      case 'document':
        return Icons.description;
      default:
        return Icons.attach_file;
    }
  }

  Widget _buildReplyPreviewInMessage(
      Message repliedMessage, bool isCurrentUser) {
    final repliedByCurrentUser = repliedMessage.senderId == 'current_user';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(Get.context!).size.width * 0.7,
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.white.withOpacity(0.2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isCurrentUser ? Colors.white : Colors.teal,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repliedByCurrentUser ? 'You' : repliedMessage.senderName!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isCurrentUser ? Colors.white : Colors.teal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            repliedMessage.content,
            style: TextStyle(
              fontSize: 12,
              color: isCurrentUser
                  ? Colors.white.withOpacity(0.9)
                  : Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMessageOverlay(Message message) {
    return Positioned(
      right: message.senderId == 'current_user' ? 16 : null,
      left: message.senderId != 'current_user' ? 16 : null,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply button
            IconButton(
              onPressed: () {
                controller.replyTo(message);
                controller.clearSelection();
              },
              icon: const Icon(
                Icons.reply,
                color: Colors.white,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            // Reaction button
            IconButton(
              onPressed: () {
                controller.selectedMessageId.value = message.id;
                controller.showReactionPicker.value = true;
              },
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.white,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            // Delete button
            IconButton(
              onPressed: () {
                controller.deleteMessage(message.id);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            // Close button
            IconButton(
              onPressed: controller.clearSelection,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionPicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: controller.availableReactions.map((emoji) {
          return GestureDetector(
            onTap: () => controller.addReaction(
              controller.selectedMessageId.value,
              emoji,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: Colors.teal.withOpacity(0.2)),
          bottom: BorderSide(color: Colors.teal.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to message',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.replyToMessage.value?.content ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.cancelReply,
            icon: Icon(
              Icons.close,
              color: Colors.grey[500],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          // Attachments preview
           controller.attachments.isNotEmpty
              ? _buildAttachmentsPreview()
              : const SizedBox.shrink(),
          Row(
            children: [
              // Attachment button
              IconButton(
                onPressed: controller.showAttachmentOptions,
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ),
              // Text input
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: controller.textController,
                    focusNode: controller.focusNode,
                    maxLines: 5,
                    minLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (value) => controller.sendMessage(),
                  ),
                ),
              ),
              // Send button
              Obx(() => Container(
                margin: const EdgeInsets.only(left: 8),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: controller.isSending.value
                        ? [Colors.grey[400]!, Colors.grey[600]!]
                        : [Colors.teal[400]!, Colors.teal[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (controller.isSending.value
                          ? Colors.grey
                          : Colors.teal)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: controller.sendMessage,
                  icon: controller.isSending.value
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPreview() {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.attachments.length,
        itemBuilder: (context, index) {
          final attachment = controller.attachments[index];
          return Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(
              right: index == controller.attachments.length - 1 ? 0 : 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getAttachmentIcon(attachment.type),
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.removeAttachment(index),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        final isCurrentUser = index % 3 == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              Container(
                width: 200,
                height: 60,
                margin: EdgeInsets.only(
                  left: isCurrentUser ? 0 : 12,
                  right: isCurrentUser ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConversationInfo() {
    final context = Get.context!;
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Participant info
                Text(
                  'Participants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                ...controller.participants
                    .where((user) => user.id != 'system')
                    .map((user) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal[200]!,
                          Colors.teal[400]!
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        user.name.split(' ').map((n) => n[0]).join(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(user.name),
                      if (user.id == 'current_user')
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.teal[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(user.role.replaceAll('_', ' ')),
                  trailing: user.id != 'current_user'
                      ? Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  )
                      : null,
                ))
                    .toList(),
                const SizedBox(height: 24),
                // Conversation stats
                Text(
                  'Conversation Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.message,
                      value: controller.messages.length.toString(),
                      label: 'Messages',
                    ),
                    _buildStatItem(
                      icon: Icons.photo,
                      value: controller.messages
                          .where((m) => m.attachments?.isNotEmpty ?? false)
                          .length
                          .toString(),
                      label: 'Media',
                    ),
                    _buildStatItem(
                      icon: Icons.call,
                      value: controller.messages
                          .where((m) => m.callInfo != null)
                          .length
                          .toString(),
                      label: 'Calls',
                    ),
                  ],
                ),
                // Your message statistics
                const SizedBox(height: 24),
                Text(
                  'Your Messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Messages',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.messages
                                .where((m) => m.senderId == 'current_user')
                                .length
                                .toString(),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.teal[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.teal,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Options
                Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  icon: Icons.notifications,
                  title: 'Mute Notifications',
                  onTap: () {},
                ),
                _buildOptionButton(
                  icon: Icons.block,
                  title: 'Block User',
                  color: Colors.red,
                  onTap: () {},
                ),
                _buildOptionButton(
                  icon: Icons.delete,
                  title: 'Delete Conversation',
                  color: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.teal,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showMessageOptions(Message message) {
    final isCurrentUser = message.senderId == 'current_user';

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
              ListTile(
                leading: const Icon(Icons.reply, color: Colors.teal),
                title: const Text('Reply'),
                onTap: () {
                  Get.back();
                  controller.replyTo(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.teal),
                title: const Text('Copy Text'),
                onTap: () {
                  Get.back();
                  // Copy to clipboard logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions, color: Colors.teal),
                title: const Text('Add Reaction'),
                onTap: () {
                  Get.back();
                  controller.selectMessage(message.id);
                  controller.showReactionPicker.value = true;
                },
              ),
              if (isCurrentUser)
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.teal),
                  title: const Text('Edit'),
                  onTap: () {
                    Get.back();
                    // Edit message logic
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                textColor: Colors.red,
                onTap: () {
                  Get.back();
                  controller.deleteMessage(message.id);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}