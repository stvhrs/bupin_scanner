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

/// Flutter code sample for [BottomNavigationBar].

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HalmanHet(),
    HalmanScan(),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      showAdaptiveDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Container(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.width * 0.65,
                  bottom: MediaQuery.of(context).size.width * 0.65),
              decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CustomRoute(
                            builder: (context) => const HalamanSoal(),
                          ));
                        },
                        child: Card(
                            surfaceTintColor:
                                const Color.fromRGBO(205, 32, 49, 1),
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    "asset/Halaman_Latihan_PAS&PTS/Icon SD@4x.png",
                                    width: 40),
                              ),
                              const Spacer(),
                              const Text(
                                "SD/MI",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(205, 32, 49, 1),
                                    fontSize: 18),
                              ),
                              const Spacer(),
                              const Spacer(),
                            ])),
                      ),
                      Card(
                          surfaceTintColor:
                              const Color.fromRGBO(58, 88, 167, 1),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  "asset/Halaman_Latihan_PAS&PTS/Icon SMP@4x.png",
                                  width: 40),
                            ),
                            const Spacer(),
                            const Text(
                              "SMP/MTS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(58, 88, 167, 1),
                                  fontSize: 18),
                            ),
                            const Spacer(),
                            const Spacer(),
                          ])),
                      Card(
                          surfaceTintColor:
                              const Color.fromRGBO(120, 163, 215, 1),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  "asset/Halaman_Latihan_PAS&PTS/Icon SMA@4x.png",
                                  width: 40),
                            ),
                            const Spacer(),
                            const Text(
                              "SMA/MA",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(120, 163, 215, 1),
                                  fontSize: 18),
                            ),
                            const Spacer(),
                            const Spacer(),
                          ])),
                    ],
                  ),
                ),
              )));
    }
  }
    wasu() async {
      try {
        response = await http.get(Uri.parse(
            "https://paling.kencang.id/api/banner/?dismissable=1&width=720&height=800"));
      } catch (e) {
        log(e.toString());
      }
    }
  Response response = Response('{}', 200);
  
  @override
  void didChangeDependencies()  {
    log("did Home");

    Timer(const Duration(milliseconds: 200), () {
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.75),
          barrierDismissible: true,
          builder: (context) {
            return  PopScope(
                              canPop: false,
                              child: FutureBuilder(
                future: wasu(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                child: GestureDetector(
                                    onTap: () {
                                  
                                      if ((jsonDecode(response.body)[0]["link"]
                                              as String)
                                          .isNotEmpty) {
                                        _launchInBrowser(Uri.parse(
                                            jsonDecode(response.body)[0]
                                                ["link"]));
                                      }
                                    },
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        jsonDecode(response.body)[0]["image"],
                                      ),
                                      placeholder: const AssetImage(
                                        "asset/place.png",
                                      ),
                                    )),
                              ),
                            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: jsonDecode(response.body)[0]
                                            ["dismissable"] ==
                                        true
                                    ? Colors.white
                                    : Colors.transparent,
                                child: IconButton(
                                    onPressed: () {
                                      if (jsonDecode(response.body)[0]
                                              ["dismissable"] ==
                                          true) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: jsonDecode(response.body)[0]
                                                  ["dismissable"] ==
                                              true
                                          ? Colors.red
                                          : Colors.transparent,
                                    )),
                              ),
                            )
                          ],
                        );
                }));
          });
    });
log("did Home2");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Buku HET',
              backgroundColor: Color.fromRGBO(70, 89, 166, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded),
              label: 'Scan',
              backgroundColor: Color.fromRGBO(70, 89, 166, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded),
              label: 'Bank Soal',
              backgroundColor: Color.fromRGBO(70, 89, 166, 1),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(70, 89, 166, 1),
          onTap: _onItemTapped,
        ),
      
    );
  }
}
