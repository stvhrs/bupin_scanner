
import 'package:Bupin/models/Het.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';
import 'package:http/http.dart' as http;

List<String> list = <String>[
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
List<String> list2 = <String>[
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

class HalmanHet extends StatefulWidget {
  const HalmanHet({super.key});

  @override
  State<HalmanHet> createState() => _HalmanHetState();
}

class _HalmanHetState extends State<HalmanHet> {
  List<Het> listHET = [];

  bool _loading = true;

  Future<void> fetchApi() async {
    listHET.clear();
    int data = list.indexOf(dropdownValue);
    final response = await http
        .get(Uri.parse("https://paling.kencang.id/api/het?kelas=${list2[data]}"));

    log(jsonDecode(response.body).toString());

    if (response.statusCode == 200) {
      for (var element in jsonDecode(response.body)) {
        listHET.add(Het.fromMap(element));
      }
      _loading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchApi();
  }
 Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("asset/Halaman_HET/Doodle HET-8.png"),
              Positioned(
                  right: 20,
                  bottom: 10,
                  child: Image.asset(
                    "asset/Halaman_HET/Bukut Het-8.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  )),
              Positioned(
                  left: 10,
                  bottom: 10,
                  child: Text(
                    "Katalog \nBuku PDF Gratis",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic),
                  )),
              Positioned(
                  left: 5,
                  top: 5,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          "asset/Halaman_HET/kemendikbud.png",
                          width: MediaQuery.of(context).size.width * 0.19,
                        ),
                      ))),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "asset/Halaman_HET/Logo Kurmer.png",
                      width: MediaQuery.of(context).size.width * 0.19,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      dropdownColor: Colors.grey.shade300,
                      iconEnabledColor: Color.fromARGB(255, 66, 66, 66),
                      icon: const Icon(
                        Icons.arrow_downward_rounded,
                        size: 16,
                        weight: 10,
                      ),
                      elevation: 16,
                      style: const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 66, 66, 66)),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
      
                        dropdownValue = value!;
                        setState(() {
                          
                        });
                        fetchApi();
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          listHET.isEmpty
              ? Expanded(
                child: Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,backgroundColor: Color.fromRGBO(236, 180, 84, 1),),
                    ),
                  ),
              )
              : Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.white,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listHET.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 0,
                          crossAxisCount: 2,
                          childAspectRatio: 0.8),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(splashColor: Theme.of(context).primaryColor,hoverColor:Theme.of(context).primaryColor,highlightColor: Theme.of(context).primaryColor,focusColor: Theme.of(context).primaryColor ,onTap: (){

                                    _launchInBrowser(Uri.parse(listHET[index].pdf));
                                  },
                                    child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: EdgeInsets.only(bottom: 8),
                                child: Container(
                                  child:  ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                            listHET[index].imgUrl,
                                           
                                          ),placeholder: AssetImage("asset/place.png",),
                                        )),
                                  
                                ),
                              ),
                              Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, right: 10),
                                child: Text(
                                  listHET[index].namaBuku,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,color:  Color.fromARGB(255, 66, 66, 66),
                                    fontSize: 10,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              )),
                            ])),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
