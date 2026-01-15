// Add this class in your models file
import 'package:myapp/models/user.dart';

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<UserProfile> participants;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isPinned;
  final String topic;
  final bool isGroup;

  Conversation({
    required this.id,
    required this.participantIds,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isPinned = false,
    required this.topic,
    this.isGroup = false,
  });
}

// Add this class for individual messages
// Add these extensions to your existing models
class MessageReaction {
  final String emoji;
  final List<String> reactedBy;

  MessageReaction({
    required this.emoji,
    required this.reactedBy,
  });
}

class MessageAttachment {
  final String id;
  final String url;
  final String type; // 'image', 'video', 'document', 'audio'
  final String? fileName;
  final int? fileSize;
  final String? thumbnailUrl;

  MessageAttachment({
    required this.id,
    required this.url,
    required this.type,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
  });
}

class CallInfo {
  final String id;
  final CallType type;
  final Duration duration;
  final DateTime startedAt;
  final bool isMissed;

  CallInfo({
    required this.id,
    required this.type,
    required this.duration,
    required this.startedAt,
    required this.isMissed,
  });
}

enum CallType {
  video,
  audio,
}

// Update the Message model to include new features
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;
  final List<MessageAttachment>? attachments;
  final MessageReaction? reaction;
  final bool isSent;
  final bool isDelivered;
  final String? replyToMessageId;
  final Message? repliedMessage;
  final CallInfo? callInfo;
  final bool isTemporary;
  final bool? isFavorite; // Add this
  final bool? isPinned; // Add this
  final bool? isEdited; // Add this

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
    this.attachments,
    this.reaction,
    this.isSent = true,
    this.isDelivered = false,
    this.replyToMessageId,
    this.repliedMessage,
    this.callInfo,
    this.isTemporary = false,
    this.isFavorite = false, // Initialize
    this.isPinned = false, // Initialize
    this.isEdited = false, // Initialize
  });

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    MessageType? type,
    List<MessageAttachment>? attachments,
    MessageReaction? reaction,
    bool? isSent,
    bool? isDelivered,
    String? replyToMessageId,
    Message? repliedMessage,
    CallInfo? callInfo,
    bool? isTemporary,
    bool? isFavorite,
    bool? isPinned,
    bool? isEdited,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      reaction: reaction ?? this.reaction,
      isSent: isSent ?? this.isSent,
      isDelivered: isDelivered ?? this.isDelivered,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      callInfo: callInfo ?? this.callInfo,
      isTemporary: isTemporary ?? this.isTemporary,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

enum MessageType {
  text,
  image,
  document,
  appointment,
}

// Add this class for message list
class MessageList {
  final String conversationId;
  final List<Message> messages;

  MessageList({
    required this.conversationId,
    required this.messages,
  });
}

