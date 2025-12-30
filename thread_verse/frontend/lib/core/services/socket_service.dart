import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api_constants.dart';
import 'storage_service.dart';

class SocketService {
  IO.Socket? _socket;
  final StorageService _storageService = StorageService();

  // Initialize socket connection
  Future<void> initSocket() async {
    final token = await _storageService.getToken();
    
    if (token == null) return;

    _socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('Connected to Socket.io server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from Socket.io server');
    });

    _socket!.onError((data) {
      print('Socket error: $data');
    });
  }

  // Join a specific room (e.g., for a post)
  void joinRoom(String room) {
    _socket?.emit('join', room);
  }

  // Leave a room
  void leaveRoom(String room) {
    _socket?.emit('leave', room);
  }

  // Listen for new comments
  void onNewComment(Function(dynamic) callback) {
    _socket?.on('new_comment', callback);
  }

  // Listen for notifications
  void onNotification(Function(dynamic) callback) {
    _socket?.on('notification', callback);
  }

  // Disconnect socket
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
