import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/community_model.dart';
import '../../models/post_model.dart';
import 'api_provider.dart';

final communityProvider = FutureProvider.family<Community, String>((ref, name) async {
  return ref.read(apiServiceProvider).getCommunity(name);
});

final communityPostsProvider = FutureProvider.family<List<Post>, String>((ref, name) async {
  return ref.read(apiServiceProvider).getPosts(communityName: name);
});
