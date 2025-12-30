import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import 'api_provider.dart';

final profileProvider = FutureProvider.family<User, String>((ref, username) async {
  return ref.read(apiServiceProvider).getUser(username);
});

final profilePostsProvider = FutureProvider.family<List<Post>, String>((ref, username) async {
  return ref.read(apiServiceProvider).getPosts(username: username);
});
