import 'package:flutter/material.dart';
import 'package:bababorg/utils/extensions/SongModelExtension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistTile extends StatelessWidget {
  final ArtistModel artistModel;

  const ArtistTile({
    required this.artistModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        artistModel.artist,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${artistModel.numberOfAlbums.toString()} Albums, ${artistModel.numberOfTracks} Songs',
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      leading: QueryArtworkWidget(
        id: artistModel.id,
        type: ArtworkType.ARTIST,
        nullArtworkWidget: const Icon(Icons.music_note),
      ),
    );
  }
}
