import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HalamanSoal extends StatefulWidget {
  const HalamanSoal({super.key});

  @override
  State<HalamanSoal> createState() => _HalamanSoalState();
}

class _HalamanSoalState extends State<HalamanSoal> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://myanimelist.net/anime/21/One_Piece'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Bank Soal'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}