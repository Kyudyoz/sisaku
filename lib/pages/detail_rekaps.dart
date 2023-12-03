import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sisaku/colors.dart';
import 'package:sisaku/models/database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'add+edit_rekap.dart';
import 'gallery_pages.dart';

class DetailRekap extends StatefulWidget {
  const DetailRekap({super.key, required this.rekap});
  final Rekap? rekap;

  @override
  State<DetailRekap> createState() => _DetailRekapsStat();
}

class _DetailRekapsStat extends State<DetailRekap>
    with SingleTickerProviderStateMixin {
  final AppDb database = AppDb();
  late int r;
  late int id;
  late TabController _tabController;

  final _selectedColor = primary;
  final _unselectedColor = base;
  final _tabs = const [
    Tab(text: 'Grafik'),
    Tab(text: 'Kategori'),
    Tab(text: 'Nama'),
  ];
  late bool isUpdate = false;
  late Map<String, double> _dataMap = {};
  // final _iconTabs = const [
  //   Tab(icon: Icon(Icons.home)),
  //   Tab(icon: Icon(Icons.search)),
  //   Tab(icon: Icon(Icons.settings)),
  // ];

  Future<void> _loadData() async {
    setState(() {});
  }

  void updateRekapView(Rekap rekap) {
    id = rekap.id;
    String name = rekap.name;
    String startDate = DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    String endDate = DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    var totalExpense = rekap.totalExpense;
    var totalIncome = rekap.totalIncome;
    var averageIncome = rekap.totalIncome;
    var averageExpense = rekap.totalExpense;
    var balance = rekap.sisa;
    var isMonthly = rekap.isMonthly;
    print('ini id $id');
  }

  void updateR(int index) {
    setState(() {
      r = index + 1;
    });
    setState(() {});
  }

  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();

    updateR(1);
    _tabController = TabController(length: 3, vsync: this);

    _loadData();
    datamap().then((dataMap) {
      setState(() {
        _dataMap = dataMap;
      });
    });
  }

  Stream<List<Rekap>> getCustomRekaps() {
    return database.getCustomRekaps();
  }

  Stream<List<Rekap>> getMonthlyRekaps() {
    return database.getMonthlyRekaps();
  }

  Future<List<Rekap>> getSingleRekap(id) {
    return database.getSingleRekaps(id);
  }

  Future<Map<String, double>> datamap() async {
    final Map<String, double> dataMap = await database.getMapFromDatabase();
    return dataMap;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future update(int id, DateTime startDate, DateTime endDate) async {
    return await database.updateRekapAmount(id, startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          primary: true,
          title: Text(
            "Detail Rekap",
            style: GoogleFonts.inder(
                fontWeight: FontWeight.w500, fontSize: 20, color: base),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined, color: base)),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                "Export",
                style: GoogleFonts.inder(
                    fontWeight: FontWeight.w500, fontSize: 14, color: base),
              ),
            )
          ],
          toolbarHeight: (MediaQuery.of(context).size.height * 0.10),
          bottom: Tab(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 12),
              child: Column(
                children: [
                  Container(
                    height: kToolbarHeight + 8.0,
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 16.0, left: 16.0),
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          color: Colors.white),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      tabs: _tabs,
                      onTap: updateR,
                    ),
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
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // Kalo Realtime
                                if (r == 1) ...[
                                  (_dataMap.isEmpty)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 85),
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
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 35),
                                          child: PieChart(
                                            dataMap: _dataMap,
                                            chartRadius: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            legendOptions: LegendOptions(
                                              legendTextStyle:
                                                  GoogleFonts.inder(),
                                              legendPosition:
                                                  LegendPosition.bottom,
                                            ),
                                            chartValuesOptions:
                                                ChartValuesOptions(
                                              showChartValuesInPercentage: true,
                                              decimalPlaces: 0,
                                            ),
                                          ),
                                        )
                                ]

                                // Kalo Kategori
                                else if (r == 2) ...[
                                  Expanded(
                                      child: FutureBuilder<List<Rekap>>(
                                    future: getSingleRekap(id),
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
                                                      snapshot.data![index]
                                                          .startDate,
                                                      snapshot.data![index]
                                                          .endDate);
                                                  isUpdate = true;
                                                }

                                                return Column(
                                                  children: [
                                                    SizedBox(height: 35),
                                                    Text(
                                                      snapshot.data![index].name
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                          Text(
                                                              "Rata-Rata Harian "),
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
                                                    SizedBox(height: 15),
                                                    Text(
                                                      "Pengeluaran Berdasarkan Kategori",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Belanja Bulanan "),
                                                          Text("XXX")
                                                        ]),
                                                    SizedBox(height: 7),
                                                    new LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      barRadius:
                                                          const Radius.circular(
                                                              16),
                                                      lineHeight: 8.0,
                                                      percent: 0.5,
                                                      progressColor: Colors.red,
                                                    ),
                                                    SizedBox(height: 25),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Makan Dan Minum "),
                                                          Text("XXX")
                                                        ]),
                                                    SizedBox(height: 7),
                                                    new LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      barRadius:
                                                          const Radius.circular(
                                                              16),
                                                      lineHeight: 8.0,
                                                      percent: 0.5,
                                                      progressColor: Colors.red,
                                                    ),
                                                    SizedBox(height: 15),
                                                    Text(
                                                      "Pemasukan Berdasarkan Kategori",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Nama Kategori Pemasukan "),
                                                          Text("XXX")
                                                        ]),
                                                    SizedBox(height: 7),
                                                    new LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      lineHeight: 8.0,
                                                      barRadius:
                                                          const Radius.circular(
                                                              16),
                                                      percent: 0.5,
                                                      progressColor:
                                                          Colors.green,
                                                    ),
                                                    SizedBox(height: 15),
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
                                                      snapshot.data![index]
                                                          .startDate,
                                                      snapshot.data![index]
                                                          .endDate);
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
                                                                  .name,
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
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        DetailRekap(
                                                                            rekap:
                                                                                snapshot.data![index]),
                                                                  ),
                                                                );
                                                                print(
                                                                    "tes edit");
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
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  // DetailPage adalah halaman yang dituju
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AddEditRekap(
                                                                            rekap:
                                                                                snapshot.data![index]),
                                                                  ),
                                                                );
                                                                print(
                                                                    "tes edit");
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
                                                                              child: Column(
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
                                  ))
                                ],
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 30),
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
        ));
  }
}
