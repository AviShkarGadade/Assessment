import 'package:assessment/repositories/user_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  int _limit = 10;
  int _skip = 0;
  List<User> _users = [];
  bool _hasMore = true;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      if (event.isRefresh) {
        _skip = 0;
        _users.clear();
        _hasMore = true;
      }

      if (!_hasMore) return;

      if (state is! UserLoaded) emit(UserLoading());

      final newUsers = await userRepository.fetchUsers(limit: _limit, skip: _skip);

      if (newUsers.length < _limit) _hasMore = false;

      _skip += _limit;
      _users.addAll(newUsers);

      emit(UserLoaded(users: _users, hasMore: _hasMore));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userRepository.searchUsers(event.query);
      emit(UserLoaded(users: users, hasMore: false));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
