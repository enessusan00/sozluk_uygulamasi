import 'package:sozluk_uygulamasi/database_access.dart';
import 'package:sozluk_uygulamasi/kelime.dart';

class KelimeDao {
  Future<List<Kelime>> tumKelimeler() async {
    var db = await DbAccess.dbAcs();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("Select * from kelimeler");
    return List.generate(maps.length, (index) {
      var satir = maps[index];
      return Kelime(satir["kelime_id"], satir["ingilizce"], satir["turkce"]);
    });
  }

  Future<List<Kelime>> kelimeArama(String kelime) async {
    var db = await DbAccess.dbAcs();
    late List<Map<String, dynamic>> maps;
    if (kelime.isEmpty || kelime == null) {
      maps = await db.rawQuery("Select * from kelimeler ");
    } else {
      maps = await db.rawQuery(
          "Select * from kelimeler where ingilizce like '%$kelime%' ");
    }

    return List.generate(maps.length, (index) {
      var satir = maps[index];
      return Kelime(satir["kelime_id"], satir["ingilizce"], satir["turkce"]);
    });
  }
}
