import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi/Kelimeler.dart';
import 'package:sozluk_uygulamasi/Kelimelerdao.dart';
import 'package:sozluk_uygulamasi/detay_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var refKelimeler = FirebaseDatabase.instance.ref("kelimeler");
  Future<void> kayit() async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["kisi_yas"] = 26;
    bilgi["kisi_ad"] = "Hakan";
    refKelimeler.push().set(bilgi);
  }

  bool aramaState = false;
  String aramaWord = "";
  final _form = GlobalKey<FormState>();

  Future<List<Kelimeler>> kelimeArama(String kelime) async {
    var kelimeler = Kelimelerdao().kelimeAra(kelime);

    return kelimeler;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaState
            ? Form(
                key: _form,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Kelime Giriniz."),
                  onChanged: (arama) {
                    setState(() {
                      aramaWord = arama;
                    });
                  },
                ))
            : Text("Kelimeler"),
        actions: [
          aramaState
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramaState = false;
                      aramaWord = "";
                    });
                  },
                  icon: Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramaState = true;
                    });
                  },
                  icon: Icon(Icons.search))
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKelimeler.onValue,
        builder: (context,event){
          if(event.hasData){
            var kelimelerListesi = <Kelimeler>[];

            var gelenDegerler = event.data!.snapshot.value as dynamic;

            if(gelenDegerler != null){
              gelenDegerler.forEach((key,nesne){

                var gelenKelime = Kelimeler.fromJson(key, nesne);

                if(aramaState){
                  if(gelenKelime.ingilizce.contains(aramaWord)){
                    kelimelerListesi.add(gelenKelime);
                  }
                }else{
                  kelimelerListesi.add(gelenKelime);
                }

              });
            }
            return ListView.builder(
                itemCount:  kelimelerListesi.length,
                itemBuilder: (context, index) {
                  var kelime = kelimelerListesi[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetayPage(kelime)));
                      },
                      child: SizedBox(
                          height: 50,
                          child: Card(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    kelime.ingilizce,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(kelime.turkce),
                                ]),
                          )));
                });
          } else {
            return Center();
          }
        },
      
      ),
    );
  }
}
