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
    return Scaffold(
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
            width: (MediaQuery.of(context).size.width < 400 ||
                    MediaQuery.of(context).size.height < 400)
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.3,
            height: (MediaQuery.of(context).size.width < 400 ||
                    MediaQuery.of(context).size.height < 400)
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.3,
            child: ScanningEffect(
              enableBorder: false,
              scanningColor: Color.fromRGBO(70, 89, 166, 1),
              delay: Duration(milliseconds: 200),
              duration: Duration(seconds: 1),
              child: Container(
                child: SizedBox(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
