import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/theme/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerScreen extends StatefulWidget {
  final String youTubeKey;
  const MovieTrailerScreen({
    Key? key,
    required this.youTubeKey,
  }) : super(key: key);

  @override
  State<MovieTrailerScreen> createState() => _MovieTrailerScreenState();
}

class _MovieTrailerScreenState extends State<MovieTrailerScreen> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youTubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
    return YoutubePlayerBuilder(
      player: player,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.mainDarkBlue,
          appBar: AppBar(
            title: const Text('Трейлер'),
          ),
          body: player,
        );
      },
    );
  }
}
