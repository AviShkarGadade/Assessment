import 'dart:convert';
import 'package:assessment/models/post_model.dart';
import 'package:assessment/models/todo_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final baseUrl = "https://dummyjson.com";

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await http.get(Uri.parse('$baseUrl/users?limit=$limit&skip=$skip'));
    if (response.statusCode == 200) {
      prefs.setString('cached_users', response.body); // cache the response
      final data = jsonDecode(response.body);
      List users = data['users'];
      return users.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  } catch (_) {
    final cached = prefs.getString('cached_users');
    if (cached != null) {
      final data = jsonDecode(cached);
      List users = data['users'];
      return users.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("No internet and no cached data available");
    }
  }
}


  Future<List<User>> searchUsers(String query) async {
  final response = await http.get(Uri.parse('$baseUrl/users/search?q=$query'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List users = data['users'];
    return users.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception("Failed to search users");
  }
}

Future<List<Post>> fetchPosts(int userId) async {
  final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId'));
  if (response.statusCode == 200) {
    List posts = jsonDecode(response.body)['posts'];
    return posts.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load posts");
  }
}

Future<List<Todo>> fetchTodos(int userId) async {
  final response = await http.get(Uri.parse('$baseUrl/todos/user/$userId'));
  if (response.statusCode == 200) {
    List todos = jsonDecode(response.body)['todos'];
    return todos.map((json) => Todo.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load todos");
  }
}

}