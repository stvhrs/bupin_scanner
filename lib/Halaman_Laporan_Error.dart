import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanLaporan extends StatelessWidget {
  final String id;
  const HalamanLaporan(this.id, {super.key});
  Future<void> _launchInBrowser() async {
    if (!await launchUrl(
      Uri.parse(
          "https://api.whatsapp.com/send/?phone=6285174484832&text=Saya+Menemukan+Kode%20QR+yang+error+berikut+kodenya+$id&type=phone_number&app_absent=0 "),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: [
        Container(
          color: Colors.white,
          alignment: Alignment.center,
        ),
        Positioned(
            top: 0,
            child: Image.asset(
              "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
              color: Colors.green.shade900,
              height: MediaQuery.of(context).size.height,fit: BoxFit.fitHeight,
              repeat: ImageRepeat.repeatY,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 5,),
         
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Mohon maaf atas ketidaknyamannya, Kode QR tersebut mengalami error, jika bersedia silahkan laporkan ke CS Admin kami, terimakasih ",
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () {
                  _launchInBrowser();
                },
                child: const Text(
                  "Laporkan ke Whatsapp CS Kami ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.white),
                )),
          
            const Spacer(flex:7,),
         
          ],
        ),
      ]),
    );
  }
}
