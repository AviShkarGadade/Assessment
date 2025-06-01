import 'package:assessment/repositories/user_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'screens/user_list_screen.dart';

// Global theme toggle notifier
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Flutter Assessment',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            scaffoldBackgroundColor: Colors.grey[100],
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
          ),
          home: BlocProvider(
            create: (_) => UserBloc(userRepository),
            child: UserListScreen(),
          ),
        );
      },
    );
  }
}
