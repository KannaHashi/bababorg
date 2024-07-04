import 'package:flutter/material.dart';
import 'package:bababorg/utils/extensions/SongModelExtension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumTile extends StatelessWidget {
  final AlbumModel albumModel;

  const AlbumTile({
    required this.albumModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        albumModel.album,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        albumModel.artist.toString(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      leading: QueryArtworkWidget(
        id: albumModel.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(Icons.music_note),
      ),
    );
  }
}
