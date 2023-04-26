import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'Global.dart';
import 'Song.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const MyApp(),
      'song': (context) => const Songs(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final assetAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "RAINBOW MUSIC",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: Global.music.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19)),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage("${Global.music[i]['image']}"),
                      ),
                      title: Text(
                        "${Global.music[i]['title']}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${Global.music[i]['subtitle']}",
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      tileColor: Colors.primaries[i % 18],
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('song', arguments: Global.music[i]);
                      },
                    ),
                  ),
                );
              },
            )));
  }
}
