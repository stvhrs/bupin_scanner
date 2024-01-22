import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:Bupin/Halaman_Laporan_Error.dart';
import 'package:Bupin/Halaman_Soal.dart';
import 'package:Bupin/Halaman_Video.dart';
import 'package:Bupin/models/Video.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:Bupin/widgets/scann_aniamtion/scanning_effect.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  final bool scanned;
  const QRViewExample(this.scanned, {super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  bool scanned = false;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void didChangeDependencies() {
    scanned = widget.scanned;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildQrView(context),
                  SizedBox(
                    width: (MediaQuery.of(context).size.height < 400)
                        ? MediaQuery.of(context).size.width / 1.7
                        : MediaQuery.of(context).size.width / 1.7,
                    height: (MediaQuery.of(context).size.height < 400)
                        ? MediaQuery.of(context).size.width / 1.7
                        : MediaQuery.of(context).size.width / 1.7,
                    child: ScanningEffect(
                      enableBorder: false,
                      scanningColor: const Color.fromRGBO(236, 180, 84, 1),
                      delay: const Duration(seconds: 1),
                      duration: const Duration(seconds: 2),
                      child: Container(
                        child: const SizedBox(),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Image.asset(
                  "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  repeat: ImageRepeat.repeat,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      color: Colors.white,
                      highlightColor: Colors.grey,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                      "Scan",
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                      "Akses Video & Soal",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromRGBO(236, 180, 84, 1),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Spacer(),
                                  Spacer(),
                                  Spacer(),
                                  Spacer(),
                                ],
                              ),
                              Positioned(
                                left: -1,
                                bottom: -1,
                                child: Image.asset(
                                  "asset/Halaman_Latihan_PAS&PTS/Bupin.png",
                                  alignment: Alignment.centerLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 8,
                          child: Image.asset(
                            "asset/Halaman_Scan/Hasan Scan2.png",
                            scale: 0.7,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  push(Response respone, String vid) async {
    scanned = await Navigator.of(context).push(CustomRoute(
        builder: (context) => (respone.data[0]["ytId"] == null &&
                respone.data[0]["ytidDmp"] == null)
            ? HalamanLaporan(vid)
            : HalamanVideo(Video.fromMap(respone.data[0]))));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.height < 400)
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.width / 2;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color.fromRGBO(70, 89, 166, 1),
          borderRadius: 6,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      try {
        if (scanned == false) {
          if (scanData.code!.contains("VID")) {
            scanned = true;
            setState(() {});
            final dio = Dio();
            String scanResult = scanData.code!;
            log(scanResult);
            scanResult = scanResult.replaceAll(
                "buku.bupin.id/?", "bupin.id/api/apibarang.php?kodeQR=");
            final response = await dio.get(scanResult);
            push(
                response,
                scanResult.replaceAll(
                    "https://bupin.id/api/apibarang.php?kodeQR=", ""));
          }
          if (scanData.code!.contains("UJN")) {
            scanned = true;
            setState(() {});

            String scanResult = scanData.code!;
            String jenjangCbt = "";

            jenjangCbt = scanResult.replaceAll("buku.bupin.id/?", "");

            int kodeTingkat = int.parse(
                jenjangCbt[jenjangCbt.indexOf(".") + 1] +
                    jenjangCbt[jenjangCbt.indexOf(".") + 2]);
            log("kode" + kodeTingkat.toString());
            String jenjang = "cbtsd";
            if (kodeTingkat == 15 ||
                kodeTingkat == 20 ||
                kodeTingkat == 26 ||
                kodeTingkat == 27 ||
                kodeTingkat == 28) {
              jenjang = "cbtsd";
            } else if (kodeTingkat == 17 ||
                kodeTingkat == 22 ||
                kodeTingkat == 24 ||
                kodeTingkat == 29 ||
                kodeTingkat == 31 ||
                kodeTingkat == 33 ||
                kodeTingkat == 34) {
              jenjang = "cbtsmp";
            } else {
              jenjang = "cbtsma";
            }

            scanResult = scanResult.replaceAll(
                "buku.bupin.id/?", "tim.bupin.id/$jenjang/login.php?");
            scanned = await Navigator.of(context).push(CustomRoute(
              builder: (context) => HalamanSoal(
                  scanResult,
                  jenjang == "cbtsd"
                      ? "Soal SD/MI"
                      : jenjang == "cbtsmp"
                          ? "Soal SMP/MI"
                          : "Soal SMA/MA",
                  true,
                  jenjang),
            ));
          }
        }
      } catch (e) {}
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}
