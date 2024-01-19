// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';
import 'package:http/http.dart' as http;

const List<String> _videoIds = [
  'fBDWlXs6wb4',
];

///
class HalamanVideo extends StatefulWidget {
  @override
  _HalamanVideoState createState() => _HalamanVideoState();
}

class _HalamanVideoState extends State<HalamanVideo> {
  double aspectRatio = 16 / 9;
  late YoutubePlayerController _controller;
  bool _loading = true;
  String _judul = "";
  Future<String> fetchApi({String id = "fBDWlXs6wb4"}) async {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(color: "blue",
          mute: false,
          showFullscreenButton: false,
          loop: false,
          strictRelatedVideos: true),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
    // fBDWlXs6wb4
    _controller.loadVideoById(videoId: "fBDWlXs6wb4");
    _judul = _controller.metadata.title;
    final response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$id&key=AIzaSyDgsDwiV1qvlNa7aes8aR1KFzRSWLlP6Bw"));

    log(jsonDecode(response.body)["items"][0]["snippet"]["localized"]
        ["description"]);
    if ((jsonDecode(response.body)["items"][0]["snippet"]["localized"]
            ["description"] as String)
        .contains("ctv")) {
      log("truee");
      aspectRatio = 9 / 16;

      _loading = false;

      return (jsonDecode(response.body)["items"][0]["snippet"]["localized"]
          ["description "] as String);
    } else {
      return _controller.metadata.title;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: fetchApi(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Color.fromRGBO(236, 180, 84, 1),
                  )),
                )
              : YoutubePlayerScaffold(
                  aspectRatio: aspectRatio,
                  controller: _controller,
                  builder: (context, player) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        title: Text(
                          "S2 MTs 7 SKI BAB 2 ILMU TASAWUF",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      body: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              player,
                              aspectRatio == 9 / 16
                                  ? SizedBox()
                                  : Stack(
                                    children: [ aspectRatio == 9 / 16?SizedBox() :Image.asset(
                                      "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
                                      width: MediaQuery.of(context).size.width,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                      Padding(
                                        padding: const EdgeInsets.only(right:0.0),
                                        child: PlayPauseButtonBar(),
                                        
                                      ),
                                    ],
                                  ), 
                              // const VideoPositionIndicator(),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
          ;
        });
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VideoPositionSeeker(),

          // MetaDataSection(),
          // _space,
          // SourceInputSection(),

          PlayPauseButtonBar(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

///
class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return StreamBuilder<YoutubeVideoState>(
      stream: context.ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inSeconds ?? 0;
        final duration = context.ytController.metadata.duration.inSeconds;

        value = position == 0 || duration == 0 ? 0 : position / duration;

        return StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              value: value,
              onChanged: (positionFraction) {
                value = positionFraction;
                setState(() {});

                context.ytController.seekTo(
                  seconds: (value * duration).toDouble(),
                  allowSeekAhead: true,
                );
              },
              min: 0,
              max: 1,
            );
          },
        );
      },
    );
  }
}
