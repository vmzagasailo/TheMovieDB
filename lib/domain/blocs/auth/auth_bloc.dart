import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/auth_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApiClient authApiClient;
  final AccountApiClient accountApiClient;
  final SessionDataProvider sessionDataProvider;

  AuthBloc(
      {required AuthState initialState,
      required this.authApiClient,
      required this.accountApiClient,
      required this.sessionDataProvider})
      : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckStatusEvent) {
        await onAuthCheckStatusEvent(event, emit);
      } else if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      } else if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(event, emit);
      }
    }, transformer: sequential());
    add(AuthCheckStatusEvent());
  }

  Future<void> onAuthCheckStatusEvent(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInProgressState());
    final sessionId = await sessionDataProvider.getSessionId();
    final newState =
        sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthInProgressState());
      final sessionId = await authApiClient.auth(
        userName: event.login,
        password: event.password,
      );
      final accountId = await accountApiClient.getAccountInfo(sessionId);
      await sessionDataProvider.setSessionId(sessionId);
      await sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }

  Future<void> onAuthLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await sessionDataProvider.deleteSessionId();
      await sessionDataProvider.deleteAccountId();
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }
}
