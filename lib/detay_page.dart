import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sozluk_uygulamasi/kelime.dart';

class DetayPage extends StatefulWidget {
  Kelime kelime;
  DetayPage(this.kelime);
  @override
  State<DetayPage> createState() => _DetayPageState();
}

class _DetayPageState extends State<DetayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detay Sayfa"),
      ),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            widget.kelime.ingilizce,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          Text(
            widget.kelime.turkce,
            style: TextStyle(   fontSize: 40),
          ),
        ]),
      ),
    );
  }
}
