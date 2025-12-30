import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/post_card.dart';
import '../widgets/community_header.dart';
import '../../../core/providers/community_provider.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityName;

  const CommunityScreen({super.key, required this.communityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityAsync = ref.watch(communityProvider(communityName));
    final postsAsync = ref.watch(communityPostsProvider(communityName));

    return Scaffold(
      appBar: AppBar(
        title: Text('r/$communityName'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(communityProvider(communityName));
          ref.refresh(communityPostsProvider(communityName));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: communityAsync.when(
                data: (community) => CommunityHeader(
                  communityName: community.name,
                  description: community.description,
                  memberCount: community.memberCount,
                  isJoined: true, // TODO: Fetch from API
                  onJoinPressed: () {},
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading community: $e'),
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
