import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_provider.dart';
import '../../../core/providers/posts_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCommunity;
  bool _isLoading = false;

  // Mock communities for dropdown - ideally fetch from API
  final List<String> _communities = ['flutterdev', 'gaming', 'photography', 'askreddit'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_titleController.text.isEmpty || _selectedCommunity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a community and enter a title')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(apiServiceProvider).createPost(
        _titleController.text.trim(),
        _contentController.text.trim(),
        _selectedCommunity!,
      );
      
      // Refresh posts list
      ref.read(postsProvider.notifier).fetchPosts();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitPost,
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Community Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCommunity,
              decoration: InputDecoration(
                labelText: 'Choose a community',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _communities.map((community) {
                return DropdownMenuItem(
                  value: community,
                  child: Text('r/$community'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCommunity = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              maxLines: null,
            ),
            const Divider(),
            // Content Input
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Body text (optional)',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            // Bottom Toolbar (Image, Link, Poll, etc.)
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.link)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.poll_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
