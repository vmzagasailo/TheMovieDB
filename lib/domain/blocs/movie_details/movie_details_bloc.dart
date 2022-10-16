import 'package:bloc/bloc.dart';

part 'movie_details_state.dart';
part 'movie_details_event.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc(super.initialState);
}
