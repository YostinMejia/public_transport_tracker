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
    on<SignUpBus>(_signUpBus);
    on<LogIn>(_signInEmailAndPassword);
  }

  Future<void> _signInAnonymously() {
    return _authRepository.signInAnonymously();
  }

  void _signInEmailAndPassword(LogIn event, Emitter<AuthState> emit) async {
    if (event.isAnonymous) {
      await _signInAnonymously();
      return;
    }
    await _authRepository.signInEmailAndPassword(event.email, event.password);
  }

  //TODO: implement a custom claim to assing user rols
  Future<Rol?> getUserRol(User user) async {
    //FIXME: implement the logic to retrieve the user's rol
    return Rol.bus;
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
          emit(
            Authenticated(user: user, rol: Rol.anonymous, isAnonymous: true),
          );
          return;
        }

        Rol? userRol = await getUserRol(user);

        if (userRol == null) {
          emit(SignInError(error: "User not found"));
          return;
        }
        emit(Authenticated(user: user, rol: userRol));
      },
      onError: (error, stackTrace) {
        emit(
          SignInError(error: "Failed to retrieve user: ${error.toString()}"),
        );
      },
    );
  }

  //TODO: learn how to implement custom claims, to assign the diferent user's rol
  void _signUpUser(SignUpUser event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.createUserWithEmailAndPassword(
        event.user.email,
        event.user.password,
      );
    } catch (e) {
      emit(SignUpError(error: e.toString()));
    }
  }

  void _signUpBus(SignUpBus event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.createUserWithEmailAndPassword(
        event.bus.email,
        event.bus.password,
      );
    } catch (e) {
      emit(SignUpError(error: e.toString()));
    }
  }
}
