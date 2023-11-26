import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sisaku/colors.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({super.key});

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  late int r;

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
    return SafeArea(
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
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 0, 5),
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
                                                  color:
                                                      (r == 1) ? base : primary,
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 5),
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
                                                  color:
                                                      (r == 2) ? base : primary,
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 5),
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
                                                "Bulanan",
                                                style: GoogleFonts.montserrat(
                                                  color:
                                                      (r == 3) ? base : primary,
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
                            (r != 3)
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 85),
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
    );
  }
}
