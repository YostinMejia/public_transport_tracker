import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:public_transport_tracker/features/user/data/repositories/user_repository.dart';
import 'package:public_transport_tracker/features/user/domain/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<UserFetch>(_fetchUser);
  }

  void _fetchUser(UserFetch event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      //FIXME: implement an actual fetch 
      final UserModel? user = await _userRepository.getUserByEmail(event.email);
      if (user == null) {
        emit(UserError(error: "User not found"));
        return;
      }

      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }
}
