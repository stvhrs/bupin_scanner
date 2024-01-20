import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Flutter code sample for [FadeTransition].

class FadeTransitionExample extends StatefulWidget {
  const FadeTransitionExample({super.key});

  @override
  State<FadeTransitionExample> createState() => _FadeTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _FadeTransitionExampleState extends State<FadeTransitionExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: FadeTransition(
        opacity: _animation,
        child: const Padding(padding: EdgeInsets.all(8), child: FlutterLogo()),
      ),
    );
  }
}

class HalamanSoal extends StatefulWidget {
  const HalamanSoal({super.key});

  @override
  State<HalamanSoal> createState() => _HalamanSoalState();
}

class _HalamanSoalState extends State<HalamanSoal>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          
        },
        onPageFinished: (String url) {_controller.forward();},
      ))
      ..loadRequest(
        Uri.parse('https://myanimelist.net/anime/21/One_Piece'),
      );
    controller.setBackgroundColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('WebView Bank Soal'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "asset/logo.png",
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          FadeTransition(
            opacity: _animation,
            child: WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}
