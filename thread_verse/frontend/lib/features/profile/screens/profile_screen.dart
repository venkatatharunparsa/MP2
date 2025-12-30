import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/post_card.dart';
import '../widgets/profile_header.dart';
import '../../post/screens/post_detail_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final String? username;

  const ProfileScreen({super.key, this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final targetUsername = username ?? currentUser?.username;

    if (targetUsername == null) {
      return const Scaffold(
        body: Center(child: Text('User not found')),
      );
    }

    final profileAsync = ref.watch(profileProvider(targetUsername));
    final postsAsync = ref.watch(profilePostsProvider(targetUsername));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          if (username == null || username == currentUser?.username)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(profileProvider(targetUsername));
          ref.refresh(profilePostsProvider(targetUsername));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (user) => ProfileHeader(
                  username: user.username,
                  bio: user.bio,
                  karma: user.karma,
                  joinedDate: 'Jan 2023', // TODO: Parse date
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading profile: $e'),
                ),
              ),
            ),
            postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('No posts yet')),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = posts[index];
                      return PostCard(
                        username: post.authorName,
                        communityName: post.communityName,
                        timeAgo: 'now', // TODO: Parse date
                        title: post.title,
                        content: post.content,
                        imageUrl: post.imageUrl,
                        upvotes: post.upvotes,
                        commentCount: post.commentCount,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(post: post.toJson()),
                            ),
                          );
                        },
                      );
                    },
                    childCount: posts.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(child: Text('Error loading posts: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
