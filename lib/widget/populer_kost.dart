import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/dummy/dummywidget.dart';

class PopulerKost extends StatefulWidget {
  const PopulerKost({Key? key}) : super(key: key);

  @override
  State<PopulerKost> createState() => _PopulerKostState();
}

class _PopulerKostState extends State<PopulerKost> {
  List<KostDummyModel> popular = [
    KostDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Skywalker",
        "Besito, Gebog", "Rp. 750.000 / bulan", 3.0, 243),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Hokage",
        "Besito, Gebog", "Rp. 550.000 / bulan", 2.0, 565),
    KostDummyModel("assets/dummykos/kost_3.png", "Laki-laki", "Kost Apasaja",
        "Besito, Gebog", "Rp. 850.000 / bulan", 5.0, 398),
    KostDummyModel("assets/dummykos/kost_4.png", "Campuran", "Kost Subadi",
        "Besito, Gebog", "Rp. 750.000 / bulan", 3.4, 745),
    KostDummyModel("assets/dummykos/kost_3.png", "Campuran", "Kost Pelangi",
        "Besito, Gebog", "Rp. 800.000 / bulan", 3.5, 321),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Star",
        "Besito, Gebog", "Rp. 900.000 / bulan", 3.7, 121),
    KostDummyModel("assets/dummykos/kost_1.png", "Perempuan", "Kost Taman",
        "Besito, Gebog", "Rp. 1.000.000 / bulan", 4.6, 111),
    KostDummyModel("assets/dummykos/kost_4.png", "Laki-laki", "Kost Regency",
        "Besito, Gebog", "Rp. 600.000 / bulan", 5.0, 123),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: popular.length,
          itemBuilder: (BuildContext context, int index) {
            return DummyItems(
              model: popular[index],
              index: index,
            );
          },
        ),
      ),
    );
  }

  appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            SharedCode.navigatorPop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
      title: Text("Populer Kost",
          style: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}
