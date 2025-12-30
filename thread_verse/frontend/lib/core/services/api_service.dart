import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/community_model.dart';
import '../models/comment_model.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  final Dio _dio = Dio();
  final StorageService _storageService = StorageService();

  ApiService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    // Add interceptor to attach token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle global errors like 401 Unauthorized here if needed
        return handler.next(e);
      },
    ));
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });
      
      final token = response.data['token'];
      final userJson = response.data['user'];
      
      await _storageService.saveToken(token);
      return User.fromJson(userJson);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<User> signup(String username, String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.signup, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      
      final token = response.data['token'];
      final userJson = response.data['user'];
      
      await _storageService.saveToken(token);
      return User.fromJson(userJson);
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  Future<List<Post>> getPosts({String? communityName, String? username}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (communityName != null) queryParams['community'] = communityName;
      if (username != null) queryParams['username'] = username;

      final response = await _dio.get(
        ApiConstants.posts,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<void> createPost(String title, String content, String communityName) async {
    try {
      await _dio.post(ApiConstants.posts, data: {
        'title': title,
        'content': content,
        'communityName': communityName,
      });
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<List<Comment>> getComments(String postId) async {
    try {
      // Assuming comments are fetched via a sub-resource or query param
      final response = await _dio.get('${ApiConstants.posts}/$postId/comments');
      final List<dynamic> data = response.data;
      return data.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<void> createComment(String postId, String content) async {
    try {
      await _dio.post('${ApiConstants.posts}/$postId/comments', data: {
        'content': content,
      });
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<Community> getCommunity(String name) async {
    try {
      final response = await _dio.get('${ApiConstants.communities}/$name');
      return Community.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch community: $e');
    }
  }

  Future<User> getUser(String username) async {
    try {
      // Assuming there's an endpoint to get user by username
      final response = await _dio.get('/users/$username');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }
}
