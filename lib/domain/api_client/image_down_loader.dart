import 'package:the_movie_db/configuration/configuration.dart';

class ImageDownLoader {
  static String imageUrl(String path) => Configuration.imageUrl + path;
}
