import 'package:flutter/material.dart';
import 'package:bababorg/utils/extensions/SongModelExtension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumGrid extends StatelessWidget {
  final AlbumModel albumModel;

  const AlbumGrid({
    required this.albumModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10
      ),
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          QueryArtworkWidget(
            id: albumModel.id,
            type: ArtworkType.ALBUM,
            artworkQuality: FilterQuality.high,
            artworkBorder: BorderRadius.circular(8),
            nullArtworkWidget: Image.asset(
              'assets/images/oke.jpeg',
              // fit: BoxFit.cover,
              width: size.width / 3,
              height: size.width / 4,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            artworkWidth: size.width / 3,
            artworkHeight: size.width / 4,
            artworkFit: BoxFit.cover,
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        albumModel.album,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        albumModel.artist ?? "Unknown Artist",
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
