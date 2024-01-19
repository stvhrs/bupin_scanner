import 'package:Bupin/qr_scan.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:Bupin/widgets/scann_aniamtion/scanning_effect.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HalmanScan extends StatefulWidget {
  const HalmanScan({super.key});

  @override
  State<HalmanScan> createState() => _HalmanScanState();
}

class _HalmanScanState extends State<HalmanScan> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(alignment: Alignment.center, children: [
          Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
          ),
          Positioned(
              top: 0,
              child: Image.asset(
                "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
                width: MediaQuery.of(context).size.width,
              )),
          Positioned(
              bottom: 0,
              child: Image.asset(
                  "asset/Halaman_Scan/Cahaya Halaman Scan@4x.png",
                  width: MediaQuery.of(context).size.width)),
          Positioned(
              bottom: 0,
              child: Image.asset("asset/Halaman_Scan/Manusia.png",
                  width: MediaQuery.of(context).size.width)),
          Positioned(
              top: 40,
              child: Image.asset("asset/Halaman_Scan/Logo Bupin@4x.png",
                  width: MediaQuery.of(context).size.width * 0.5)),
          Positioned(
              top: 180,
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
        backgroundColor: Color.fromRGBO(70, 89, 166, 1),
        floatingActionButton: Stack(
          alignment: Alignment.center,
          children: [
            FloatingActionButton(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Color.fromRGBO(70, 89, 166, 1),
                  size: 40,
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(CustomRoute(
                    builder: (context) => QRViewExample(),
                  ));
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              child: ScanningEffect(
                enableBorder: false,
                scanningColor: Color.fromRGBO(236, 180, 84, 1),
                delay: Duration(milliseconds: 200),
                duration: Duration(seconds: 2),
                child: Container(
                  child: SizedBox(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }
}
