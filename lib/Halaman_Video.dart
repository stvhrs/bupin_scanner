// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:Bupin/models/Video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/play_pause_button_bar.dart';


///
class HalamanVideo extends StatefulWidget {
  final Video video;

  const HalamanVideo(
    this.video, {super.key}
  );
  @override
  _HalamanVideoState createState() => _HalamanVideoState();
}

class _HalamanVideoState extends State<HalamanVideo>
    with TickerProviderStateMixin {
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..animateTo(1);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller2,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }

  double aspectRatio = 16 / 9;
  late YoutubePlayerController _controller;


  Future<String> fetchApi({String id = "fBDWlXs6wb4"}) async {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
          color: "blue",
          mute: false,
          showFullscreenButton: false,
          loop: false,
          strictRelatedVideos: true),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {},
    );

    _controller.loadVideo(widget.video.linkVideo!);
final dio = Dio();
    final response = await dio.get(
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=${widget.video.ytId}&key=AIzaSyDgsDwiV1qvlNa7aes8aR1KFzRSWLlP6Bw");
    log(response.data["items"][0]["snippet"]["localized"]
            ["description"]
        .toString());

    if ((response.data["items"][0]["snippet"]["localized"]
            ["description"] as String)
        .contains("ctv")) {
      aspectRatio = 9 / 16;

    

      return (response.data["items"][0]["snippet"]["localized"]
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
    
    return PopScope(canPop: false,
      child: FutureBuilder<String>(
          future: fetchApi(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: const Color.fromRGBO(236, 180, 84, 1),
                    )),
                  )
                :  YoutubePlayerScaffold(
                      backgroundColor: Colors.black,
                      aspectRatio: aspectRatio,
                      controller: _controller,
                      builder: (context, player) {
                        return Scaffold(
                          backgroundColor: Colors.white,
                          appBar: AppBar(
                            centerTitle: true,
                            leading: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 15,
                                        weight: 100,
                                      ),
                                    ),
                                  )),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            title: Text(
                              widget.video.namaVideo!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          body:  LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Column(
                                      children: [
                                        Stack(alignment: Alignment.center, children: [
                            Image.asset(
                              "asset/logo.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            FadeTransition(
                                opacity: _animation,
                                child:player)]),
                                        aspectRatio == 9 / 16
                                            ? const SizedBox()
                                            : Stack(
                                                children: [
                                                  aspectRatio == 9 / 16
                                                      ? const SizedBox()
                                                      : Image.asset(
                                                          "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            right: 0.0),
                                                    child: PlayPauseButtonBar(),
                                                  ),
                                                ],
                                              ),
                                        // const VideoPositionIndicator(),
                                      ],
                                    );
                                  },
                                ));
                         
                        
                      },
                    
                  );
          }),
    );
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoPositionSeeker(),

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
