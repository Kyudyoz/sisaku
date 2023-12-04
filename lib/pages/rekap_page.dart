import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sisaku/colors.dart';
import 'package:sisaku/models/database.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/detail_rekaps.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/setting_page.dart';

import 'add+edit_rekap.dart';
import 'gallery_pages.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({super.key});

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  final AppDb database = AppDb();
  late int r;
  bool isUpdate = false;
  // Map<String, double> dataMap = {
  //   "Balance": 253000,
  //   "Belanja Bulanan": 35000,
  //   "Makan dan Minum": 12000,
  // };
  bool datakosong = false;

  late Map<String, double> _dataMap = {};

  @override
  void initState() {
    super.initState();
    updateR(1);
    _loadData();
    datamap().then((dataMap) {
      setState(() {
        _dataMap = dataMap;
      });
    });
  }

  void updateR(int index) {
    setState(() {
      r = index;
    });

    isUpdate = false;
  }

  Stream<List<Rekap>> getCustomRekaps() {
    return database.getCustomRekaps();
  }

  Stream<List<Rekap>> getMonthlyRekaps() {
    return database.getMonthlyRekaps();
  }

  Future update(int id, DateTime startDate, DateTime endDate) async {
    return await database.updateRekapAmount(id, startDate, endDate);
  }

  // Future<List<Rekap>> getRekaps() async {
  //   return await database.getRekaps();
  // }

  Future<Map<String, double>> datamap() async {
    final Map<String, double> dataMap = await database.getMapFromDatabase();
    return dataMap;
  }

  Future<void> _loadData() async {
    setState(() {});
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
              style: GoogleFonts.inder(
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
                                                  "Realtime",
                                                  style: GoogleFonts.inder(
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
                                                  style: GoogleFonts.inder(
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
                                                  style: GoogleFonts.inder(
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
                            children: [
                              // Kalo Realtime
                              if (r == 1) ...[
                                // (_dataMap.isEmpty)
                                //     ? Padding(
                                //         padding: const EdgeInsets.only(top: 85),
                                //         child: Column(
                                //           children: [
                                //             Image.asset(
                                //               'assets/img/tes.png',
                                //               width: 200,
                                //             ),
                                //             Text(
                                //               "Tidak Ada Data",
                                //               style: GoogleFonts.inder(),
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     :

                                Expanded(
                                  child: FutureBuilder<Map<String, double>>(
                                    future: datamap(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length > 0) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 35),
                                                      child: PieChart(
                                                        dataMap: _dataMap,
                                                        chartRadius:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.7,
                                                        legendOptions:
                                                            LegendOptions(
                                                          legendTextStyle:
                                                              GoogleFonts
                                                                  .inder(),
                                                          legendPosition:
                                                              LegendPosition
                                                                  .right,
                                                        ),
                                                        chartValuesOptions:
                                                            ChartValuesOptions(
                                                          showChartValuesInPercentage:
                                                              true,
                                                          decimalPlaces: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 85),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 35),
                                                  Image.asset(
                                                    'assets/img/tes.png',
                                                    width: 200,
                                                  ),
                                                  Text(
                                                    "Belum ada transaksi",
                                                    style: GoogleFonts.inder(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
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
                                          );
                                        }
                                      }
                                    },
                                  ),
                                )
                              ]

                              // Kalo Bulanan
                              else if (r == 2) ...[
                                Expanded(
                                    child: StreamBuilder<List<Rekap>>(
                                  stream: getMonthlyRekaps(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.length > 0) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              String startDate =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate);
                                              String endDate =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .endDate);
                                              if (!isUpdate) {
                                                update(
                                                    snapshot.data![index].id,
                                                    snapshot
                                                        .data![index].startDate,
                                                    snapshot
                                                        .data![index].endDate);

                                                isUpdate = true;
                                              }

                                              return Column(
                                                children: [
                                                  SizedBox(height: 35),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .name
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(width: 10),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        // Pindah ke halaman Edit Rekap
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            // DetailPage adalah halaman yang dituju
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailRekap(
                                                                      rekap: snapshot
                                                                              .data![
                                                                          index]),
                                                            ),
                                                          );
                                                          print("tes edit");
                                                        },
                                                        color: primary,
                                                        hoverColor: secondary,
                                                        icon: Icon(Icons
                                                            .arrow_forward_ios),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Durasi "),
                                                        Text(startDate +
                                                            " ~ " +
                                                            endDate),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Total Pengeluaran "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .totalExpense
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Total Pemasukan "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .totalIncome
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Sisa "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .sisa
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 30),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 35),
                                                Image.asset(
                                                  'assets/img/tes.png',
                                                  width: 200,
                                                ),
                                                Text(
                                                  "Belum ada transaksi pada bulan ini",
                                                  style: GoogleFonts.inder(),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      } else {
                                        return Padding(
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
                                                style: GoogleFonts.inder(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ))

                                // Kalo Custom
                              ] else if (r == 3) ...[
                                Expanded(
                                    child: StreamBuilder<List<Rekap>>(
                                  stream: getCustomRekaps(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.length > 0) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              String startDate =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate);
                                              String endDate =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .endDate);
                                              if (!isUpdate) {
                                                update(
                                                    snapshot.data![index].id,
                                                    snapshot
                                                        .data![index].startDate,
                                                    snapshot
                                                        .data![index].endDate);
                                                isUpdate = true;
                                              }

                                              return Column(
                                                children: [
                                                  SizedBox(height: 35),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .name
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(width: 35),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            // Pindah ke halaman Detail Rekap
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailRekap(
                                                                          rekap:
                                                                              snapshot.data![index]),
                                                                ),
                                                              );
                                                              print("tes edit");
                                                            },
                                                            color: primary,
                                                            hoverColor:
                                                                secondary,
                                                            icon: Icon(Icons
                                                                .arrow_forward_ios),
                                                          ),
                                                          IconButton(
                                                            // Pindah ke halaman edit
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                // DetailPage adalah halaman yang dituju
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AddEditRekap(
                                                                          rekap:
                                                                              snapshot.data![index]),
                                                                ),
                                                              );
                                                              print("tes edit");
                                                            },
                                                            color: primary,
                                                            focusColor:
                                                                secondary,
                                                            hoverColor:
                                                                secondary,
                                                            iconSize: 20,
                                                            icon: Icon(
                                                                Icons.edit),
                                                          ),
                                                          IconButton(
                                                              // Pindah ke halaman Detail Rekap
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        shadowColor:
                                                                            Colors.red[50],
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Center(
                                                                                  child: Text(
                                                                                    'Yakin ingin Hapus?',
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 30,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text(
                                                                                        'Batal',
                                                                                        style: GoogleFonts.inder(
                                                                                          color: home,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                        database.deleteRekap(snapshot.data![index].id);
                                                                                        setState(() {
                                                                                          print(
                                                                                            "Berhasil Hapus Semua",
                                                                                          );
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        'Ya',
                                                                                        style: GoogleFonts.inder(
                                                                                          color: base,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              color: primary,
                                                              focusColor:
                                                                  secondary,
                                                              hoverColor:
                                                                  secondary,
                                                              iconSize: 20,
                                                              icon: Icon(Icons
                                                                  .delete)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Durasi "),
                                                        Text(startDate +
                                                            " ~ " +
                                                            endDate),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Total Pengeluaran "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .totalExpense
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Total Pemasukan "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .totalIncome
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Sisa "),
                                                        Text("Rp." +
                                                            snapshot
                                                                .data![index]
                                                                .sisa
                                                                .toString()),
                                                      ]),
                                                  SizedBox(height: 30),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
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
                                          );
                                        }
                                      } else {
                                        return Padding(
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
                                                style: GoogleFonts.inder(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ))
                              ],
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(primary),
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
                                  style: GoogleFonts.inder(
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      // DetailPage adalah halaman yang dituju
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditRekap(rekap: null),
                                      ),
                                    );
                                  },
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
