import 'package:assessment/repositories/user_repositories.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final UserRepository repo = UserRepository();
  List<Post> posts = [];
  List<Todo> todos = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final fetchedPosts = await repo.fetchPosts(widget.user.id);
    final fetchedTodos = await repo.fetchTodos(widget.user.id);
    setState(() {
      posts = fetchedPosts;
      todos = fetchedTodos;
      isLoading = false;
    });
  }

  void _addPost() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isNotEmpty && body.isNotEmpty) {
      final newPost = Post(
        id: posts.length + 1,
        userId: widget.user.id,
        title: title,
        body: body,
      );
      setState(() {
        posts.insert(0, newPost);
      });
      _titleController.clear();
      _bodyController.clear();
      Navigator.pop(context);
    }
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Create Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: "Body"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(onPressed: _addPost, child: Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.firstName} ${widget.user.lastName}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.email,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),

                  Text("Posts", style: Theme.of(context).textTheme.titleLarge),
                  ...posts.map(
                    (post) => Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          post.title,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(post.body),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text("Todos", style: Theme.of(context).textTheme.titleLarge),
                  ...todos.map(
                    (todo) => CheckboxListTile(
                      value: todo.completed,
                      title: Text(todo.todo),
                      onChanged: null,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
