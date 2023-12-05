import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sisaku/models/database.dart';

// import 'package:sisaku/colors.dart';
import 'package:sisaku/models/transaction_with_category.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'package:sisaku/pages/setting_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late int type;
  final AppDb database = AppDb();

  void initState() {
    updateType(1);
    super.initState();
  }

  void updateType(int index) {
    setState(() {
      type = index;
    });
    print("tipe sekarang : " + type.toString());
  }

  Stream<List<TransactionWithCategory>> getGallery() {
    return database.getGallery(type);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gallery",
                  style: GoogleFonts.montserrat(
                    fontSize: 23,
                    color: base,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (type == 1) ? primary : base,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      topLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download_outlined,
                                        color: (type == 1)
                                            ? base
                                            : Colors.green[300],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          updateType(1);
                                        },
                                        child: Text(
                                          "Pemasukan",
                                          style: GoogleFonts.montserrat(
                                            color: (type == 1) ? base : primary,
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
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (type == 2) ? primary : base,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          updateType(2);
                                        },
                                        child: Text(
                                          "Pengeluaran",
                                          style: GoogleFonts.montserrat(
                                            color: (type == 2) ? base : primary,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.upload_outlined,
                                        color: (type == 2)
                                            ? base
                                            : Colors.red[300],
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
              ],
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<List<TransactionWithCategory>>(
                        stream: getGallery(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.hasData) {
                              if (snapshot.data!.length > 0) {
                                return SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Wrap(
                                          spacing: 20,
                                          runSpacing: 20,
                                          children: snapshot.data!
                                              .map((e) => Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              // title: Text(
                                                              //   e.transaction
                                                              //           .name +
                                                              //       " (" +
                                                              //       e.category
                                                              //           .name +
                                                              //       ")",
                                                              //   style:
                                                              //       GoogleFonts
                                                              //           .inder(
                                                              //     fontSize: 28,
                                                              //   ),
                                                              // ),
                                                              content: Stack(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image: MemoryImage(e.transaction.image ??
                                                                            Uint8List(0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.7,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(10),
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1,
                                                                      height:
                                                                          MediaQuery.of(context).size.height /
                                                                              6,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            e.transaction.name +
                                                                                " (" +
                                                                                e.category.name +
                                                                                ")",
                                                                            style:
                                                                                GoogleFonts.inder(
                                                                              fontSize: 28,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: base,
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                3,
                                                                            color:
                                                                                base,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Tanggal Transaksi",
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 14,
                                                                                      color: base,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    DateFormat('dd-MMMM-yyyy').format(e.transaction.transaction_date),
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 14,
                                                                                      color: base,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 20,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(border: Border.all(color: base)),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    'Jumlah Uang',
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 14,
                                                                                      color: base,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    'Rp. ' +
                                                                                        (NumberFormat.currency(
                                                                                          locale: 'id',
                                                                                          decimalDigits: 0,
                                                                                        ).format(
                                                                                          e.transaction.amount,
                                                                                        )).replaceAll('IDR', ''),
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 14,
                                                                                      color: base,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              scrollable: true,
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2.8,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: MemoryImage(e
                                                                      .transaction
                                                                      .image ??
                                                                  Uint8List(0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            e.transaction.name +
                                                                " (" +
                                                                e.category
                                                                    .name +
                                                                ")",
                                                            style: GoogleFonts
                                                                .inder(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                              .toList()
                                              .toSet()
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 85),
                                  child: Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 35),
                                        Image.asset(
                                          'assets/img/tes.png',
                                          width: 200,
                                        ),
                                        Text(
                                          "Belum ada transaksi dengan bergambar",
                                          style: GoogleFonts.inder(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 85),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/img/tes.png',
                                        width: 200,
                                      ),
                                      Text(
                                        "Tidak Ada Data",
                                        style: GoogleFonts.inder(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
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
                      builder: (context) =>
                          HomePage(selectedDate: DateTime.now()),
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
                  color: Colors.black,
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
