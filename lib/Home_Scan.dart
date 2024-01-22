import 'dart:developer';

import 'package:Bupin/Halaman_Camera.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:Bupin/widgets/scann_aniamtion/scanning_effect.dart';

import 'package:flutter/material.dart';

class HalmanScan extends StatefulWidget {
  const HalmanScan({super.key});

  @override
  State<HalmanScan> createState() => _HalmanScanState();
}

class _HalmanScanState extends State<HalmanScan> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  double width = 0;
  @override
  Widget build(BuildContext context) {
    log("scan");
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Container(
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
        ),
        Positioned(
            top: 0,
            child: Image.asset(
              "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
              width: width,
            )),
        Positioned(
            bottom: 0,
            child: Image.asset("asset/Halaman_Scan/Cahaya Halaman Scan@4x.png",
                width: width)),
        Positioned(
            bottom: 0,
            child: Image.asset("asset/Halaman_Scan/Manusia.png", width: width)),
        Positioned(
            top: 50,
            child: Image.asset(
              "asset/Halaman_Scan/Logo Bupin@4x.png",
              width: width * 0.5,
            )),
        const Positioned(
            top: 200,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ayo Belajar Bersama",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 24,
                      height: 0.3),
                ),
                Text("BUPIN 4.0",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 50)),
                Text("Scan dengan tekan tombol ini",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(236, 180, 84, 1),
                        fontSize: 20)),
              ],
            ))
      ]),
      backgroundColor: const Color.fromRGBO(70, 89, 166, 1),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
              backgroundColor: const Color.fromRGBO(70, 89, 166, 1),
              onPressed: () {
                Navigator.of(context).push(CustomRoute(
                  builder: (context) => const QRViewExample(false),
                ));
              },
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 40,
              )),
          SizedBox(
            width: width * 0.3,
            height: width * 0.3,
            child: const ScanningEffect(
              enableBorder: false,
              scanningColor: Color.fromRGBO(236, 180, 84, 1),
              delay: Duration(milliseconds: 200),
              duration: Duration(seconds: 2),
              child: SizedBox(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
