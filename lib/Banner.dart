import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Bupin/Halaman_Soal.dart';
import 'package:Bupin/Home_Het.dart';
import 'package:Bupin/Home_Scan.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanBanner extends StatefulWidget {
  final Map<String, dynamic> data;
  const HalamanBanner(this.data);

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
  void didChangeDependencies() {
    log("did Home");

    log("did Home2");
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return closed == true
        ? SizedBox()
        : Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: PopScope(
                canPop: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        child: GestureDetector(
                            onTap: () {
                              if ((widget.data["link"] as String).isNotEmpty) {
                                _launchInBrowser(
                                    Uri.parse(widget.data["link"]));
                              }
                            },
                            child: FadeInImage(
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset("asset/place.png"),
                              image: NetworkImage(
                                widget.data["image"],
                              ),
                              placeholder: const AssetImage(
                                "asset/place.png",
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: widget.data["dismissable"] == true
                            ? Colors.white
                            : Colors.transparent,
                        child: IconButton(
                            onPressed: () {
                              if (widget.data["dismissable"] == true) {
                                closed = true;
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.close,
                              color: widget.data["dismissable"] == true
                                  ? Colors.red
                                  : Colors.transparent,
                            )),
                      ),
                    )
                  ],
                )),
          );
  }
}
