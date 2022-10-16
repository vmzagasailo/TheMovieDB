import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:the_movie_db/domain/blocs/auth/auth_bloc.dart';


enum LoaderScreenState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderScreenState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(
    LoaderScreenState initialState,
    this.authBloc,
  ) : super(initialState) {
    Future.microtask(
      () {
        _onState(authBloc.state);
        authBlocSubscription = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckStatusEvent());
      },
    );
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderScreenState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderScreenState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}