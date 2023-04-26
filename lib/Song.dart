import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> with TickerProviderStateMixin {
  final assetAudioPlayer = AssetsAudioPlayer();
  AnimationController? musicController;

  bool stat = true;
  @override
  void initState() {
    super.initState();
    musicController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    super.dispose();
    assetAudioPlayer.dispose();
    musicController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    assetAudioPlayer.open(Audio(data['audio']));
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  data['title'],
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  data['subtitle'],
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          assetAudioPlayer.stop();
                        },
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.white,
                        )),
                    StreamBuilder(
                        stream: assetAudioPlayer.isPlaying,
                        builder: (cnt, snp) {
                          if (snp.data!) {
                            musicController!.forward();
                          }
                          return IconButton(
                              onPressed: () {
                                if (snp.data!) {
                                  assetAudioPlayer.pause();
                                  musicController!.reverse();
                                } else {
                                  assetAudioPlayer.play();
                                  musicController!.forward();
                                }
                              },
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: musicController!,
                                color: Colors.white,
                              ));
                        }),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.headphones,
                          color: Colors.white,
                        )),
                  ],
                ),
                StreamBuilder(
                    stream: assetAudioPlayer.currentPosition,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Slider(
                            value: snapshot.data!.inSeconds.toDouble(),
                            onChanged: (val) {
                              setState(() {
                                assetAudioPlayer
                                    .seek(Duration(seconds: val.toInt()));
                              });
                            },
                            max: (assetAudioPlayer.current.value != null)
                                ? assetAudioPlayer
                                        .current.value?.audio.duration.inSeconds
                                        .toDouble() ??
                                    0
                                : 0,
                            min: 0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white54,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data.toString().split('.')[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "/",
                                style: TextStyle(color: Colors.white),
                              ),
                              (assetAudioPlayer.current.value != null)
                                  ? Text(
                                      "${assetAudioPlayer.current.value?.audio.duration.toString().split('.')[0]}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : const Text(
                                      "0:00:00",
                                      style: TextStyle(color: Colors.white),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      );
                    })
              ],
            ),
          )
        ],
      ),
    ));
  }
}
