import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movie_db/domain/api_client/api_client_exception.dart';
import 'package:the_movie_db/domain/blocs/auth/auth_bloc.dart';
import 'package:the_movie_db/ui/screens/auth/cubit/auth_view_state.dart';

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(
    AuthViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Enter login and password');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthUnauthorizedState) {
      emit(AuthScreenFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitSuccessAuthState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckStatusInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Unknown error, please try again';
    }
    switch (error.typeError) {
      case ApiClientExceptionType.networkError:
        return 'Server is not available. Check internet connection.';
      case ApiClientExceptionType.authError:
        return 'Wrong password or login';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.otherError:
        return 'Unknown error, please try again';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
