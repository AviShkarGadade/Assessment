import 'package:assessment/main.dart';
import 'package:assessment/screens/user_detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import '../blocs/user/user_state.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context)..add(FetchUsers());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _userBloc.add(FetchUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),

        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _userBloc.add(SearchUsers(value)),
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _userBloc.add(FetchUsers(isRefresh: true));
              },
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading &&
                      (_userBloc.state is! UserLoaded)) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UserError) {
                    return Center(child: Text(state.message));
                  } else if (state is UserLoaded) {
                    if (state.users.isEmpty) {
                      return Center(child: Text("No users found"));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.users.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.users.length) {
                          final user = state.users[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.image),
                                radius: 25,
                              ),
                              title: Text(
                                "${user.firstName} ${user.lastName}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(user.email),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserDetailScreen(user: user),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
