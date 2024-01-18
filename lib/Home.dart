
import 'package:Bupin/Home_Het.dart';
import 'package:Bupin/Home_Scan.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [BottomNavigationBar].

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon( Icons.qr_code_scanner_rounded),
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
        selectedItemColor: Color.fromRGBO(70, 89, 166, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
