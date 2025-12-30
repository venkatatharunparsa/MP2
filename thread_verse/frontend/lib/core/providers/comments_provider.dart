import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/comment_model.dart';
import 'api_provider.dart';

final commentsProvider = FutureProvider.family<List<Comment>, String>((ref, postId) async {
  return ref.read(apiServiceProvider).getComments(postId);
});
