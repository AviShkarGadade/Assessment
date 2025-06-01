import 'package:assessment/repositories/user_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'screens/user_list_screen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  final userRepository = UserRepository();
  runApp(MyApp(userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Flutter Assessment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: currentMode,
          home: BlocProvider(
            create: (_) => UserBloc(userRepository),
            child: UserListScreen(),
          ),
        );
      },
    );
  }
}
