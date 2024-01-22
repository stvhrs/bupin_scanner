import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class HalamanBanner extends StatefulWidget {
  const HalamanBanner({super.key});

  @override
  State<HalamanBanner> createState() => _HalamanBannerState();
}

bool closed = false;

class _HalamanBannerState extends State<HalamanBanner> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    closed = true;

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Map<String, dynamic> data = {};
  Future<Map<String, dynamic>> checkBanner() async {
    try {
      final dio = Dio();
      final response = await dio.get("https://paling.kencang.id/api/banner/");
      data = response.data[0];
      return data;
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return closed == true
        ? const SizedBox()
        : FutureBuilder<Object>(
            future: checkBanner(),
            builder: (context, snapshot) {
              return PopScope(
                  canPop: false,
                  child: Center(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? Scaffold(
                            backgroundColor: Colors.black.withOpacity(0.7),
                            body: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                                backgroundColor:
                                    const Color.fromRGBO(236, 180, 84, 1),
                              ),
                            ))
                        : data["image"] == null
                            ? Builder(builder: (context) {
                                closed = true;
                                return const SizedBox();
                              })
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                child: GestureDetector(
                                    onTap: () {
                                      if ((data["link"] as String).isNotEmpty) {
                                        _launchInBrowser(
                                            Uri.parse(data["link"]));
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        FadeInImage(
                                          imageErrorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset("asset/place.png"),
                                          image: NetworkImage(
                                            data["image"],
                                          ),
                                          placeholder: const AssetImage(
                                            "asset/place.png",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                data["dismissable"] == true
                                                    ? Colors.white
                                                    : Colors.transparent,
                                            child: IconButton.outlined(
                                                color: Colors.red,
                                                focusColor: Colors.red,
                                                hoverColor: Colors.red,
                                                onPressed: () {
                                                  if (data["dismissable"] ==
                                                      true) {
                                                    closed = true;
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: data["dismissable"] ==
                                                          true
                                                      ? Colors.red
                                                      : Colors.transparent,
                                                )),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                  ));
            });
  }
}
