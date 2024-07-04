import 'package:flutter/material.dart';
import 'package:bababorg/utils/extensions/SongModelExtension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTile extends StatelessWidget {
  final SongModel songModel;

  const MusicTile({
    required this.songModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 6,
      width: size.width / 3,
      child: ListTile(
        isThreeLine: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              songModel.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              songModel.album.toString(),
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 40),
            )
          ],
        ),
        subtitle: Text(songModel.additionalSongInfo),
        leading: QueryArtworkWidget(
          id: songModel.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Icon(Icons.music_note),
        ),
      ),
    );
  }
}
