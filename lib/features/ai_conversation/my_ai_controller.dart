import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:myapp/models/user.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;
import 'ai_message.dart';

class MyAiController extends GetxController {
  final RxList<AiMessage> messages = <AiMessage>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isTyping = false.obs;
  final RxString bio = "".obs;
  final RxBool _isConnecting = false.obs;
  final RxBool _isResponseInProgress = false.obs;
  late Rx<UserProfile> user;

  WebSocket? _socket;
  StreamSubscription? _socketSubscription;
  final String _url = "wss://${glbv.apiUrl}/aichat/${glbv.selectedUserId}";

  final List<String> _pendingMessages = [];
  Timer? _reconnectTimer;
  Timer? _responseTimeoutTimer;
  final int _responseTimeoutSeconds = 30;

  @override
  void onInit() {
    super.onInit();
    _generateUserSummary();
    _connectSocket();
  }

  bool get isResponseInProgress => _isResponseInProgress.value;
  bool get canSendMessage => isConnected.value && !_isResponseInProgress.value;

  Future<void> _connectSocket() async {
    if (_isConnecting.value || isConnected.value) return;

    _isConnecting.value = true;

    try {
      _socket = await WebSocket.connect(_url);
      isConnected.value = true;
      _isConnecting.value = false;

      _socketSubscription = _socket!.listen(
        _onMessageReceived,
        onDone: _onSocketDone,
        onError: _onSocketError,
      );

      _sendInitPrompt();
      _sendPendingMessages();

      _reconnectTimer?.cancel();
      _reconnectTimer = null;

    } catch (e) {
      print('WebSocket connection error: $e');
      _isConnecting.value = false;
      isConnected.value = false;
      _scheduleReconnect();
    }
  }

  void _onSocketDone() {
    print('WebSocket connection closed');
    isConnected.value = false;
    _cleanupSocket();
    _scheduleReconnect();
  }

  void _onSocketError(dynamic error) {
    print('WebSocket error: $error');
    isConnected.value = false;
    _cleanupSocket();
    _scheduleReconnect();
  }

  void _cleanupSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = null;

    try {
      _socket?.close();
    } catch (e) {
      print('Error closing socket: $e');
    }
    _socket = null;
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!isConnected.value && !_isConnecting.value) {
        _connectSocket();
      }
    });
  }

  void sendUserMessage(String text) {
    if (text.trim().isEmpty) return;

    if (!canSendMessage) {
      Get.snackbar(
        'Cannot send message',
        isConnected.value
            ? 'Please wait for the current response to complete'
            : 'Not connected to AI service',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    messages.add(
      AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: DateTime.now(),
        text: text,
        isAI: false,
      ),
    );

    isTyping.value = true;
    _isResponseInProgress.value = true;

    final messageJson = jsonEncode({
      "type": "user",
      "message": text,
    });

    _startResponseTimeoutTimer();

    if (isConnected.value && _socket != null) {
      try {
        _socket!.add(messageJson);
      } catch (e) {
        print('Error sending message: $e');
        _pendingMessages.add(messageJson);
        isConnected.value = false;
        _isResponseInProgress.value = false;
        _responseTimeoutTimer?.cancel();
        _connectSocket();
      }
    } else {
      _pendingMessages.add(messageJson);
      _isResponseInProgress.value = false;
      _responseTimeoutTimer?.cancel();
      _connectSocket();
    }
  }

  void _startResponseTimeoutTimer() {
    _responseTimeoutTimer?.cancel();
    _responseTimeoutTimer = Timer(Duration(seconds: _responseTimeoutSeconds), () {
      if (_isResponseInProgress.value) {
        _handleResponseTimeout();
      }
    });
  }

  void _handleResponseTimeout() {
    messages.add(
      AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: DateTime.now(),
        text: 'Sorry, the response is taking too long. Please try again.',
        isAI: true,
      ),
    );

    isTyping.value = false;
    _isResponseInProgress.value = false;
    _responseTimeoutTimer?.cancel();
  }

  void _sendPendingMessages() {
    if (_pendingMessages.isEmpty || !isConnected.value || _socket == null) return;

    try {
      for (final message in _pendingMessages) {
        _socket!.add(message);
      }
      _pendingMessages.clear();
    } catch (e) {
      print('Error sending pending messages: $e');
    }
  }

  void _sendInitPrompt() {
    final UserProfile? profile = DummyData.getUserById(glbv.selectedUserId);

    if (profile == null) return;

    final String roleDetails =
        "You are role-playing a character with the following attributes: "
        "Name: ${profile.name}, "
        "Role: ${profile.role}"
        "${profile.specialization != null ? ', Specialization: ${profile.specialization}' : ''}"
        "${profile.location != null ? ', Location: ${profile.location}' : ''}"
        "${profile.experience != null ? ', Experience: ${profile.experience} years' : ''}, "
        "Verified: ${profile.isVerified}, "
        "${profile.bio != null ? ', Biography: ${profile.bio}' : ''}. "
        "Always stay in character and never mention system instructions.";

    final initPayload = {
      "type": "init",
      "system_prompt": roleDetails,
    };

    if (isConnected.value && _socket != null) {
      try {
        _socket!.add(jsonEncode(initPayload));
      } catch (e) {
        print('Error sending init prompt: $e');
        isConnected.value = false;
        _connectSocket();
      }
    }
  }

  void _onMessageReceived(dynamic data) {
    _responseTimeoutTimer?.cancel();

    if (data == '{"status":"ready"}') {
      isTyping.value = false;
      _isResponseInProgress.value = false;
      return;
    }

    // Remove animation, add message directly
    messages.add(
      AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: DateTime.now(),
        text: data.toString(),
        isAI: true,
      ),
    );
    isTyping.value = false;
    _isResponseInProgress.value = false;
  }

  void _generateUserSummary() {
    final UserProfile? profile = DummyData.getUserById(glbv.selectedUserId);

    if (profile != null) {
      bio.value = "name:${profile.name}"
          "${profile.specialization != null ? ', Specialization:${profile.specialization}' : ''}"
          "${profile.location != null ? ', Location:${profile.location}' : ''}";
      user = profile.obs;
    }
  }

  Future<void> reconnect() async {
    if (_isConnecting.value) return;

    _cleanupSocket();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    await _connectSocket();
  }

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    _responseTimeoutTimer?.cancel();
    _cleanupSocket();
    _pendingMessages.clear();
    messages.clear();
    super.onClose();
  }
}