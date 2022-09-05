import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi/Kelimeler.dart';
import 'package:sozluk_uygulamasi/Kelimelerdao.dart';
import 'package:sozluk_uygulamasi/detay_page.dart';
void main() {
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
  bool aramaState = false;
  String aramaWord = "";
  final _form = GlobalKey<FormState>();

  Future<List<Kelimeler>> kelimeleriGetir() async {
    var kelimeler = Kelimelerdao().tumKelimeler();

    return kelimeler;
  }

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
      body: FutureBuilder<List<Kelimeler>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var kelimeler = snapshot.data;
            return ListView.builder(
                itemCount: kelimeler!.length,
                itemBuilder: (context, index) {
                  var kelime = kelimeler[index];
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
        future: aramaState ? kelimeArama(aramaWord) : kelimeleriGetir(),
      ),
    );
  }
}
