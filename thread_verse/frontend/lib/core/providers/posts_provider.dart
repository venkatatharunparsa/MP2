import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post_model.dart';
import 'api_provider.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, AsyncValue<List<Post>>>((ref) {
  return PostsNotifier(ref);
});

class PostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final Ref _ref;

  PostsNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      state = const AsyncValue.loading();
      final posts = await _ref.read(apiServiceProvider).getPosts();
      state = AsyncValue.data(posts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
