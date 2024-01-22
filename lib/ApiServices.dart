import 'dart:developer';

import 'package:Bupin/Halaman_Laporan_Error.dart';
import 'package:Bupin/Halaman_Soal.dart';
import 'package:Bupin/Halaman_Video.dart';
import 'package:Bupin/models/Het.dart';
import 'package:Bupin/models/Video.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  'SD/MI  I',
  'SD/MI  II',
  'SD/MI  III',
  'SD/MI  IV',
  'SD/MI  V',
  'SD/MI  VI',
  'SMP/MTS  VII',
  "SMP/MTS  VIII",
  "SMP/MTS  IX",
  "SMA/MA  X",
  "SMA/MA  XI",
  "SMA/MA  XII"
];
const List<String> listKelas = <String>[
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  "VIII",
  "IX",
  "X",
  "XI",
  "XII"
];

class ApiService {
  Future<List<Het>> fetchHet(String dropdownValue) async {
    try {
      List<Het> listHet = [];
      final dio = Dio();
      int data = list.indexOf(dropdownValue);
      final response = await dio
          .get("https://paling.kencang.id/api/het?kelas=${listKelas[data]}");

      if (response.statusCode == 200) {
        for (Map<String, dynamic> element in response.data) {
          listHet.add(Het.fromMap(element));
        }

        return listHet;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> checkBanner() async {
    try {
      final dio = Dio();
      final response = await dio.get("https://paling.kencang.id/api/banner/");

      return response.data[0];
    } catch (e) {
      return {};
    }
  }

  static Future<bool> isVertical(Video video) async {
    final dio = Dio();
    final response = await dio.get(
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=${video.ytId}&key=AIzaSyDgsDwiV1qvlNa7aes8aR1KFzRSWLlP6Bw");

    if ((response.data["items"][0]["snippet"]["localized"]["description"]
            as String)
        .contains("ctv")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> pushToVideo(
    Response data, String vid, BuildContext context) async {
    return await Navigator.of(context).push(CustomRoute(
        builder: (context) =>
            (data.data[0]["ytid"] == null && data.data[0]["ytidDmp"] == null)
                ? HalamanLaporan(vid)
                : HalamanVideo(Video.fromMap(data.data[0]))));
  }

  Future<bool> pushToCbt(
      String scanResult, String jenjang, BuildContext context) async {
    return await Navigator.of(context).push(CustomRoute(
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

  Future<bool> scanQrCbt(String link, BuildContext context) async {
    String jenjangCbt = "";

    jenjangCbt = link.replaceAll("buku.bupin.id/?", "");

    int kodeTingkat = int.parse(jenjangCbt[jenjangCbt.indexOf(".") + 1] +
        jenjangCbt[jenjangCbt.indexOf(".") + 2]);

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

    link =
        link.replaceAll("buku.bupin.id/?", "tim.bupin.id/$jenjang/login.php?");
    return await pushToCbt(link, jenjang, context);
  }

  Future<bool> scanQrVideo(String link, BuildContext context) async {
    final dio = Dio();

    link = link.replaceAll(
        "buku.bupin.id/?", "bupin.id/api/apibarang.php?kodeQR=");
    final response = await dio.get(link);
    return await pushToVideo(
        response,
        link.replaceAll(
          "https://bupin.id/api/apibarang.php?kodeQR=",
          "",
        ),
        context);
  }
}
