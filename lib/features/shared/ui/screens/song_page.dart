import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../provider/song_model_provider.dart';
import 'package:bababorg/features/shared/ui/screens/neu_box.dart';

class SongPage extends StatefulWidget {
  final List<SongModel> songModelList;
  final AudioPlayer audioPlayer;

  const SongPage(
      {Key? key, required this.songModelList, required this.audioPlayer})
      : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  List<AudioSource> songList = [];

  int currentIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong() {
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }

      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      );
      
      widget.audioPlayer.play();
      _isPlaying = true;

      widget.audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });

      widget.audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });

      listenToEvent();
      listenToSongIndex();
    } on Exception catch (_) {
      popBack();
    }
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(widget.songModelList[currentIndex].id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // back button and menu button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  popBack();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('P L A Y L I S T'),
              SizedBox(
                height: 60,
                width: 60,
                child: NeuBoxDark(child: Icon(Icons.menu)),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // cover art, artist name, song name
          NeuBoxDark(
            child: Column(
              children: [
                const Center(
                  child: ArtWorkWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.songModelList[currentIndex].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.songModelList[currentIndex].artist
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey.shade200,
                                overflow: TextOverflow.fade),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 32,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          // start time, shuffle button, repeat button, end time
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('0:00'),
              Icon(Icons.shuffle),
              Icon(Icons.repeat),
              Text('4:22')
            ],
          ),

          const SizedBox(height: 30),

          // linear bar
          Row(children: [
            Text(_position.toString().split(".")[0]),
            Expanded(
                child: Slider(
              min: 0.0,
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  seekToSeconds(value.toInt());
                  value = value;
                });
              },
            )),
            Text(_duration.toString().split(".")[0])
          ]),

          const SizedBox(height: 30),

          // previous song, pause play, skip next song
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: NeuBoxDark(
                      child: IconButton(
                    onPressed: () {
                      if (widget.audioPlayer.hasPrevious) {
                        widget.audioPlayer.seekToPrevious();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 24.0,
                    ),
                  )),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: NeuBoxDark(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (_isPlaying) {
                                  widget.audioPlayer.pause();
                                } else {
                                  widget.audioPlayer.play();
                                }
                                _isPlaying = context
                                    .read<SongModelProvider>()
                                    .setPlaying(true);
                              });
                            },
                            icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow))),
                  ),
                ),
                Expanded(
                  child: NeuBoxDark(
                      child: IconButton(
                    onPressed: () {
                      if (widget.audioPlayer.hasNext) {
                        widget.audioPlayer.seekToNext();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 24.0,
                    ),
                  )),
                ),
              ],
            ),
          )
        ],
      ),
    )));
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
        id: context.watch<SongModelProvider>().id,
        type: ArtworkType.AUDIO,
        artworkHeight: 500,
        artworkWidth: 500,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Image.asset('lib/images/oke.jpeg'));
  }
}
