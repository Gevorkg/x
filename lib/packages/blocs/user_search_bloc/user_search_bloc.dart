import 'package:flutter_bloc/flutter_bloc.dart';
import '../../user_repository/user_repos.dart';
import 'user_search_event.dart';
import 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final UserRepository _userRepository;

  UserSearchBloc(this._userRepository) : super(UsersInitial()) {
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onSearchUsers(
      SearchUsersEvent event, Emitter<UserSearchState> emit) async {
    emit(UsersLoading());
    try {
        final users = await _userRepository.getAllUsers();
        final filteredUsers = users.where((user) {
        final nameLower = user.name.toLowerCase();
        final nicknameLower = user.nickname.toLowerCase();
        final queryLower = event.query.toLowerCase();
          return nameLower.contains(queryLower) ||
            nicknameLower.contains(queryLower);
       }).toList();

      emit(UsersLoaded(filteredUsers));
    } catch (e) {
      emit(UsersError('Failed to load users'));
    }
  }
}
