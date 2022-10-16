import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/image_down_loader.dart';
import 'package:the_movie_db/ui/resources/app_images.dart';
import 'package:the_movie_db/ui/screens/movie_detail_screen/provider/movie_details_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailCastWidget extends StatelessWidget {
  const MovieDetailCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text('Series cast'),
        ),
        const SizedBox(
          height: 250,
          child: Scrollbar(
            child: _ActorsListWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3),
          child: TextButton(
            onPressed: () {},
            child: const Text('Full cast & Crew'),
          ),
        )
      ]),
    );
  }
}

class _ActorsListWidget extends StatelessWidget {
  const _ActorsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actorData =
        context.select((MovieDetailsProvider model) => model.data.actorData);
    return ListView.builder(
      itemCount: actorData.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return _ActorItemWidget(
          actorIndex: index,
        );
      }),
    );
  }
}

class _ActorItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorItemWidget({
    Key? key,
    required this.actorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsProvider>();
    final actor = model.data.actorData[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            profilePath != null
                ? Image(
                    image: NetworkImage(ImageDownLoader.imageUrl(profilePath)),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : const Image(
                    image: AssetImage(AppImages.personPlaceHolder),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actor.name,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    actor.character,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
