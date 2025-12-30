import '../shared/widgets/post_card.dart';

final List<Map<String, dynamic>> mockPosts = [
  {
    'username': 'tech_guru',
    'communityName': 'flutterdev',
    'timeAgo': '2h',
    'title': 'Flutter 3.19 is out! What are your thoughts?',
    'content': 'I really like the new Gemini API integration. Has anyone tried it yet?',
    'upvotes': 1240,
    'commentCount': 89,
    'imageUrl': null,
  },
  {
    'username': 'nature_lover',
    'communityName': 'photography',
    'timeAgo': '5h',
    'title': 'Sunset at the beach',
    'content': null,
    'upvotes': 3500,
    'commentCount': 210,
    'imageUrl': 'https://picsum.photos/seed/sunset/600/400',
  },
  {
    'username': 'gamer_123',
    'communityName': 'gaming',
    'timeAgo': '1d',
    'title': 'Elden Ring DLC announced!',
    'content': 'Finally! I have been waiting for this for so long. The trailer looks amazing.',
    'upvotes': 15000,
    'commentCount': 4500,
    'imageUrl': 'https://picsum.photos/seed/gaming/600/400',
  },
];

final List<Map<String, dynamic>> mockComments = [
  {
    'username': 'flutter_fan',
    'timeAgo': '1h',
    'content': 'This looks amazing! Can\'t wait to try it out.',
    'upvotes': 45,
    'depth': 0,
  },
  {
    'username': 'dart_vader',
    'timeAgo': '30m',
    'content': 'I agree, the new features are game changers.',
    'upvotes': 12,
    'depth': 1,
  },
  {
    'username': 'random_user',
    'timeAgo': '2h',
    'content': 'Does anyone know if this supports the new impeller engine?',
    'upvotes': 8,
    'depth': 0,
  },
];

final List<Map<String, dynamic>> mockNotifications = [
  {
    'username': 'flutter_fan',
    'action': 'commented on your post',
    'content': 'This looks amazing!',
    'timeAgo': '1h',
    'isRead': false,
  },
  {
    'username': 'dart_vader',
    'action': 'upvoted your post',
    'content': null,
    'timeAgo': '2h',
    'isRead': true,
  },
  {
    'username': 'moderator_bot',
    'action': 'welcomed you to',
    'content': 'r/flutterdev',
    'timeAgo': '1d',
    'isRead': true,
  },
];
