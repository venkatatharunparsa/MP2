import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/post_card.dart';
import '../../post/screens/post_detail_screen.dart';
import '../../post/screens/create_post_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/providers/posts_provider.dart';
import '../../../core/providers/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThreadVerse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              final currentUser = ref.read(currentUserProvider);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileScreen(username: currentUser?.username)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(postsProvider.notifier).fetchPosts();
        },
        child: postsAsyncValue.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  username: post.authorName,
                  communityName: post.communityName,
                  timeAgo: _getTimeAgo(post.createdAt),
                  title: post.title,
                  content: post.content,
                  imageUrl: post.imageUrl,
                  upvotes: post.upvotes,
                  commentCount: post.commentCount,
                  onTap: () {
                    // Convert Post model to map for PostDetailScreen if needed, 
                    // or update PostDetailScreen to accept Post model.
                    // For now, let's assume PostDetailScreen needs update or we pass map.
                    // But wait, PostDetailScreen was using map from mock data.
                    // I should probably update PostDetailScreen to accept Post model later.
                    // For now, I'll construct a map to keep it working without breaking changes elsewhere yet.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post.toJson()),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(postsProvider.notifier).fetchPosts();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
