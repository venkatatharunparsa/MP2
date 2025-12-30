import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/post_card.dart';
import '../../../shared/widgets/comment_tile.dart';
import '../../../core/providers/comments_provider.dart';
import '../../../core/providers/api_provider.dart';
import '../../../core/providers/socket_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    final postId = widget.post['id'] ?? '1';
    final socketService = ref.read(socketServiceProvider);
    
    socketService.joinRoom('post_$postId');
    socketService.onNewComment((data) {
      // Refresh comments when a new one arrives
      ref.refresh(commentsProvider(postId));
    });
  }

  @override
  void dispose() {
    final postId = widget.post['id'] ?? '1';
    ref.read(socketServiceProvider).leaveRoom('post_$postId');
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    try {
      final postId = widget.post['id'] ?? '1'; // Fallback for mock data
      await ref.read(apiServiceProvider).createComment(
        postId,
        _commentController.text.trim(),
      );
      
      _commentController.clear();
      // Refresh comments
      ref.refresh(commentsProvider(postId));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment posted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.post['id'] ?? '1';
    final commentsAsync = ref.watch(commentsProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PostCard(
                    username: widget.post['authorName'] ?? widget.post['username'],
                    communityName: widget.post['communityName'],
                    timeAgo: widget.post['timeAgo'] ?? 'now',
                    title: widget.post['title'],
                    content: widget.post['content'],
                    imageUrl: widget.post['imageUrl'],
                    upvotes: widget.post['upvotes'],
                    commentCount: widget.post['commentCount'],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No comments yet. Be the first!')),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = comments[index];
                          return CommentTile(
                            username: comment.authorName,
                            timeAgo: 'now', // TODO: Parse date
                            content: comment.content,
                            upvotes: 0, // TODO: Add upvotes to Comment model
                            depth: 0, // TODO: Handle nested comments
                          );
                        },
                        childCount: comments.length,
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
                      child: Center(child: Text('Error loading comments: $e')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: _isPosting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
                  onPressed: _isPosting ? null : _postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
