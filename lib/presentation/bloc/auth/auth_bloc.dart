import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:public_transport_tracker/data/repositories/auth_repository.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthRepository _authRepository;
  AuthBloc({required authRepository}) : super(AuthLoading()) {
    _authRepository = authRepository;
    on<StartAuthListen>(_startAuthSubscription);
    on<SignUpUser>(_signUpUser);
  }

  Future<void> signInAnonymously() {
    return _authRepository.signInAnonymously();
  }

  //TODO: implement a custom claim to assing user rols
  Future<String?> getUserRol(String? token) async {
    return "user";
  }

  void _startAuthSubscription(
    StartAuthListen event,
    Emitter<AuthState> emit,
  ) async {
    await emit.onEach(
      _authRepository.authStateChanges(),
      onData: (user) async {
        if (user == null) {
          emit(UnAuthenticated());
          return;
        }

        if (user.isAnonymous) {
          emit(AnonymouslyAuthenticated(user: user));
          return;
        }
        try {
          String? token = await user.getIdToken();
          String? userRol = await getUserRol(token);
          if (userRol == null) {
            emit(ErrorSignIn(error: "User not found"));
            return;
          }
          if (userRol == "bus") {
            emit(BusAuthenticated(bus: user));
            return;
          } else {
            emit(UserAuthenticated(user: user));
            return;
          }
        } catch (e) {
          emit(ErrorSignIn(error: "Failed to retrieve user: ${e.toString()}"));
        }
      },
      onError: (error, stackTrace) {
        emit(
          ErrorSignIn(error: "Failed to retrieve user: ${error.toString()}"),
        );
      },
    );
  }

  void _signUpUser(SignUpUser event, Emitter<AuthState> emit) async {
    await _authRepository.createUserWithEmailAndPassword(
      event.user.email,
      event.user.email,
    );
    // await _authRepository.createUser(event.user, user.credential.toString());
  }
}
