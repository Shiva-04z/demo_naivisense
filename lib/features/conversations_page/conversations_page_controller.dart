import 'package:get/get.dart';

import '../../core/globals/dummy_data.dart';
import '../../models/conversation.dart';

class ConversationsPageController extends GetxController {
  var conversations = <Conversation>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedFilter = 'All'.obs;

  final List<String> filters = ['All', 'Unread', 'Pinned', 'Groups'];

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  void loadConversations() {
    isLoading.value = true;

    // Simulate API delay
    Future.delayed(Duration(milliseconds: 800), () {
      conversations.value = DummyData.getConversations();
      // Randomize the list to show different conversations each time
      conversations.shuffle();
      isLoading.value = false;
    });
  }

  void refreshConversations() {
    loadConversations();
  }

  void searchConversations(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      loadConversations();
    } else {
      conversations.value = DummyData.getConversations().where((conv) {
        final participants = conv.participants;
        final searchText = query.toLowerCase();

        return participants.any((user) =>
        user.name.toLowerCase().contains(searchText) ||
            user.specialization!.toLowerCase().contains(searchText) ?? false ||
            conv.topic.toLowerCase().contains(searchText) ||
            conv.lastMessage.toLowerCase().contains(searchText)
        );
      }).toList();
    }
  }

  void filterConversations(String filter) {
    selectedFilter.value = filter;

    switch (filter) {
      case 'Unread':
        conversations.value = DummyData.getConversations()
            .where((conv) => conv.unreadCount > 0)
            .toList();
        break;
      case 'Pinned':
        conversations.value = DummyData.getConversations()
            .where((conv) => conv.isPinned)
            .toList();
        break;
      case 'Groups':
        conversations.value = DummyData.getConversations()
            .where((conv) => conv.isGroup)
            .toList();
        break;
      default:
        loadConversations();
    }
  }

  void markAsRead(Conversation conversation) {
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      conversations[index] = Conversation(
        id: conversation.id,
        participantIds: conversation.participantIds,
        participants: conversation.participants,
        lastMessage: conversation.lastMessage,
        lastMessageTime: conversation.lastMessageTime,
        unreadCount: 0,
        isPinned: conversation.isPinned,
        topic: conversation.topic,
        isGroup: conversation.isGroup,
      );
      conversations.refresh();
    }
  }

  void togglePin(Conversation conversation) {
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      conversations[index] = Conversation(
        id: conversation.id,
        participantIds: conversation.participantIds,
        participants: conversation.participants,
        lastMessage: conversation.lastMessage,
        lastMessageTime: conversation.lastMessageTime,
        unreadCount: conversation.unreadCount,
        isPinned: !conversation.isPinned,
        topic: conversation.topic,
        isGroup: conversation.isGroup,
      );
      conversations.refresh();
    }
  }

  void deleteConversation(String conversationId) {
    conversations.removeWhere((conv) => conv.id == conversationId);
  }
}