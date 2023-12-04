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

  // Data Detail Rekap dari Rekap yang dipilih
  late int id;
  late String name;
  late String startDate;
  late String endDate;
  late var dbStartDate;
  late var dbEndDate;
  late var totalExpense;
  late var totalIncome;
  late var averageIncome;
  late var averageExpense;
  late int totalTransactions;
  late var balance;
  late bool isMonthly;
  late double dailyAverage;

  // Untuk dapetin categoi
  late var getCategory;
  // Tab
  late TabController _tabController;

  final _selectedColor = primary;
  final _unselectedColor = base;
  final _tabs = const [
    Tab(text: 'Grafik'),
    Tab(text: 'Kategori'),
    Tab(text: 'Nama'),
  ];
  late bool isUpdate = false;

  late Map<String, List> _dataMapCategory = {};
  late Map<String, double> _dataMapChart = {};

  // final _iconTabs = const [
  //   Tab(icon: Icon(Icons.home)),
  //   Tab(icon: Icon(Icons.search)),
  //   Tab(icon: Icon(Icons.settings)),
  // ];

  Future<void> _loadData() async {
    setState(() {});
  }

  Future<Map<String, List>?> getDataMapCategory(
      DateTime startDate, DateTime endDate) async {
    final dataMap = await database.getCategoryNameByRekaps(startDate, endDate);

    return dataMap;
  }

  void updateRekapView(Rekap rekap) {
    id = rekap.id;
    name = rekap.name;
    print("Ini startDate :" + rekap.startDate.toString());

    startDate = DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    endDate = DateFormat('dd-MMMM-yyyy').format(rekap.endDate);

    // Untuk Query
    dbStartDate = rekap.startDate;
    dbEndDate = rekap.endDate;
    totalTransactions = rekap.totalTransactions!;
    totalExpense = rekap.totalExpense;
    totalIncome = rekap.totalIncome;
    averageIncome = rekap.totalIncome;
    averageExpense = rekap.totalExpense;
    balance = rekap.sisa;
    isMonthly = rekap.isMonthly;
    print('ini id $id');
  }

  Future<Map<String, double>> datamap() async {
    final Map<String, double> dataMap = await database.getMapFromDatabase();

    return dataMap;
  }

  double getDailyAverage(int totalExpense, int totalIncome) {
    dailyAverage = (totalExpense + totalIncome) / totalTransactions;
    return dailyAverage;
  }

  void updateR(int index) {
    setState(() {
      r = index + 1;
    });
    setState(() {});
  }

  // Kalkulasi persen berdasarkan kategori
  double calculatePercentage(double categoryAmount, double totalAmount) {
    if (totalAmount > 0) {
      return categoryAmount / totalAmount;
    } else {
      return 0.0;
    }
  }

  double totalExpenseAmounts = 0;
  double totalIncomeAmounts = 0;

  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();
    getDataMapCategory(dbStartDate, dbEndDate).then((datamap) {
      setState(() {
        _dataMapCategory = datamap!;
        print("Ini dataMap Category  $_dataMapCategory");
      });
    });
    final data = _dataMapCategory["Pemasukan"];
    print("Ini dataMap Category  $_dataMapCategory");
    print("Tes Hasil nama value $data");
    getDailyAverage(totalExpense, totalIncome);
    updateR(1);

    _tabController = TabController(length: 3, vsync: this);

    _loadData();
    datamap().then((dataMap) {
      setState(() {
        _dataMapChart = dataMap;
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
          title: Text(
            "Detail Rekap",
            style: GoogleFonts.inder(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: base,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: base),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                "Export",
                style: GoogleFonts.inder(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: base,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
            child: Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  tabs: _tabs,
                  onTap: updateR,
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
                          Expanded(
                            child: Column(
                              children: [
                                // Kalo Realtime
                                if (r == 1) ...[
                                  (_dataMapChart.isEmpty)
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
                                            dataMap: _dataMapChart,
                                            chartRadius: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            legendOptions: LegendOptions(
                                              legendTextStyle:
                                                  GoogleFonts.inder(),
                                              legendPosition:
                                                  LegendPosition.right,
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
                                      child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 35),
                                        Text(
                                          name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Durasi "),
                                              Text(startDate + " ~ " + endDate),
                                            ]),
                                        SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Pengeluaran "),
                                              Text(
                                                "Rp." +
                                                    (NumberFormat.currency(
                                                      locale: 'id',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      totalExpense,
                                                    )).replaceAll('IDR', ''),
                                              ),
                                            ]),
                                        SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Pemasukan "),
                                              Text(
                                                "Rp." +
                                                    (NumberFormat.currency(
                                                      locale: 'id',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      totalIncome,
                                                    )).replaceAll('IDR', ''),
                                              ),
                                            ]),
                                        SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Rata-Rata Harian "),
                                              Text(
                                                "Rp." +
                                                    (NumberFormat.currency(
                                                      locale: 'id',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      dailyAverage,
                                                    )).replaceAll('IDR', ''),
                                              ),
                                            ]),
                                        SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Sisa "),
                                              Text(
                                                "Rp." +
                                                    (NumberFormat.currency(
                                                      locale: 'id',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      totalIncome,
                                                    )).replaceAll('IDR', ''),
                                              ),
                                            ]),
                                        SizedBox(height: 15),
                                        Text(
                                          "Pengeluaran Berdasarkan Kategori",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),

                                        // Data dari Database
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              _dataMapCategory["expenseName"]
                                                      ?.length ??
                                                  0,
                                          itemBuilder: (context, index) {
                                            final expenseName =
                                                _dataMapCategory["expenseName"]
                                                        ?[index] ??
                                                    '';
                                            final expenseAmount =
                                                _dataMapCategory[
                                                            "expenseAmount"]
                                                        ?[index] ??
                                                    0;

                                            totalExpenseAmounts +=
                                                expenseAmount.toDouble();
                                            return Column(
                                              children: [
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        expenseName), // Nama kategori expense
                                                    Text("Rp." +
                                                        (NumberFormat.currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          expenseAmount,
                                                        )).replaceAll('IDR',
                                                            '')), // Total Expense
                                                  ],
                                                ),
                                                SizedBox(height: 7),
                                                LinearPercentIndicator(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  barRadius:
                                                      const Radius.circular(16),
                                                  lineHeight: 8.0,
                                                  percent: calculatePercentage(
                                                      expenseAmount.toDouble(),
                                                      totalExpenseAmounts), // Ganti nilai persentase sesuai kebutuhan
                                                  progressColor: Colors.red,
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        // Mapping Data Income
                                        SizedBox(height: 25),
                                        Text(
                                          "Pemasukan Berdasarkan Kategori",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              _dataMapCategory["incomeName"]
                                                      ?.length ??
                                                  0,
                                          itemBuilder: (context, index) {
                                            final incomeName =
                                                _dataMapCategory["incomeName"]
                                                        ?[index] ??
                                                    '';
                                            final incomeAmount =
                                                _dataMapCategory["incomeAmount"]
                                                        ?[index] ??
                                                    0;
                                            totalExpenseAmounts +=
                                                incomeAmount.toDouble();
                                            return Column(
                                              children: [
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        incomeName), // Nama kategori income
                                                    Text("Rp." +
                                                        (NumberFormat.currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          incomeAmount,
                                                        )).replaceAll('IDR',
                                                            '')), // Total Income
                                                  ],
                                                ),
                                                SizedBox(height: 7),
                                                LinearPercentIndicator(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  barRadius:
                                                      const Radius.circular(16),
                                                  lineHeight: 8.0,
                                                  percent: calculatePercentage(
                                                      incomeAmount.toDouble(),
                                                      totalExpenseAmounts), // Ganti nilai persentase sesuai kebutuhan
                                                  progressColor: Colors.red,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(height: 25),
                                      ],
                                    ),
                                  )
                                      // Kalo Custom
                                      )
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