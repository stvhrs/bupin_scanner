import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HalamanSoal extends StatefulWidget {
  final  String url ;
  const HalamanSoal(this.url, {super.key});

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
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation2 = CurvedAnimation(
    parent: _controller2,
    curve: Curves.easeIn,
  );
  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
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
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          _controller2.animateBack(0);
          _controller.forward();
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
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
          FadeTransition(
            opacity: _animation,
            child: WebViewWidget(controller: controller),
          ),
          FadeTransition(
            opacity: _animation2,
            child: Image.asset(
              "asset/logo.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
