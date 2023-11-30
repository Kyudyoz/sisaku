import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sisaku/colors.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/setting_page.dart';

import 'gallery_pages.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({super.key});

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  late int r;

  Map<String, double> dataMap = {
    "Balance": 253000,
    "Belanja Bulanan": 35000,
    "Makan dan Minum": 12000,
  };

  @override
  void initState() {
    updateR(1);
    super.initState();
  }

  void updateR(int index) {
    setState(() {
      r = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          color: primary,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Text(
              "Rekap",
              style: GoogleFonts.montserrat(
                fontSize: 23,
                color: base,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                      BorderSide(color: primary)),
                                  color: base,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 0, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 1) ? primary : base,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(1);
                                                },
                                                child: Text(
                                                  "Semua",
                                                  style: GoogleFonts.montserrat(
                                                    color: (r == 1)
                                                        ? base
                                                        : primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 2) ? primary : base,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(2);
                                                },
                                                child: Text(
                                                  "Bulanan",
                                                  style: GoogleFonts.montserrat(
                                                    color: (r == 2)
                                                        ? base
                                                        : primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 3) ? primary : base,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(3);
                                                },
                                                child: Text(
                                                  "Custom",
                                                  style: GoogleFonts.montserrat(
                                                    color: (r == 3)
                                                        ? base
                                                        : primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (r == 3)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 85),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/img/tes.png',
                                            width: 200,
                                          ),
                                          Text(
                                            "Tidak Ada Data",
                                            style: GoogleFonts.montserrat(),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        // Image.asset(
                                        //   'assets/img/tes.png',
                                        //   width: 200,
                                        // ),
                                        // Text(
                                        //   "Tidak Ada Data",
                                        //   style: GoogleFonts.montserrat(),
                                        // ),

                                        PieChart(
                                          dataMap: dataMap,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.7,
                                          legendOptions: LegendOptions(
                                            legendTextStyle:
                                                GoogleFonts.montserrat(),
                                            legendPosition:
                                                LegendPosition.bottom,
                                          ),
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            showChartValuesInPercentage: true,
                                            decimalPlaces: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    // DetailPage adalah halaman yang dituju
                                    MaterialPageRoute(
                                      builder: (context) => GalleryPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Lihat Galeri',
                                  style: GoogleFonts.montserrat(
                                    color: base,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: (r == 3) ? true : false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 30),
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: primary,
                                  child: Icon(
                                    Icons.add,
                                    color: base,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: primary,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                ),
              ),
            ),

            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RekapPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.bar_chart,
                  color: primary,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
