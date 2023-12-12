import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
// import 'package:sisaku/colors.dart';
import 'package:sisaku/pages/setting_page.dart';

import 'package:sisaku/models/database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sisaku/pages/transaction_page.dart';
import 'package:sisaku/widgets/details.dart';
import '../models/transaction_with_category.dart';
// import 'add+edit_rekap.dart';
// import 'gallery_pages.dart';

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
  // final _unselectedColor = base;

  final _tabs = [
    Tab(text: (lang == 0) ? 'Grafik' : "Chart"),
    Tab(text: (lang == 0) ? 'Kategori' : "Category"),
    Tab(text: (lang == 0) ? 'Nama' : "Name"),
  ];
  late bool isUpdate = false;

  // late Map<String, List> _dataMapCategory = {};
  late Map<String, double> _dataMapChart = {};

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

//  getCategoryNameByRekaps

  double getDailyAverage(int totalExpense, int totalIncome) {
    dailyAverage = (totalExpense + totalIncome) / totalTransactions;
    return dailyAverage;
  }

  void updateR(int index) {
    setState(() {
      r = index + 1;
    });
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
  // late Map<String, double> _dataMap = {};
  Future<Map<String, double>> datamap() async {
    final Map<String, double> dataMap = await database.getMapFromDatabase();
    return dataMap;
  }

  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();

    // getDataMapCategory(dbStartDate, dbEndDate).then((datamap) {
    //   setState(() {
    //     _dataMapCategory = datamap as Map<String, List>;
    //     print("Ini dataMap Category  $_dataMapCategory");
    //   });
    // });

    // final data = _dataMapCategory["Pemasukan"];
    // print("Ini dataMap Category  $_dataMapCategory");
    // print("Tes Hasil nama value $data");
    getDailyAverage(totalExpense, totalIncome);

    _tabController = TabController(length: 3, vsync: this);

    updateR(0);
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

  final rekap_detail = Rekap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          (lang == 0) ? "Detail Rekap" : "Recap Details",
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
                  color: (isDark) ? background : base,
                ),
                labelColor: (isDark) ? base : Colors.black87,
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
                  color: (isDark) ? background : Colors.white,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Kalo Chart
                              if (r == 1) ...[
                                Expanded(
                                  child: FutureBuilder<Map<String, double>>(
                                    future: datamap(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      primary)),
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
                                                        dataMap: _dataMapChart,
                                                        chartRadius:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.7,
                                                        legendOptions:
                                                            LegendOptions(
                                                          legendTextStyle:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
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
                                                    (lang == 0)
                                                        ? "Belum ada transaksi"
                                                        : "No transactions yet",
                                                    style: GoogleFonts.inder(
                                                        color: isDark
                                                            ? base
                                                            : home),
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
                                                  (lang == 0)
                                                      ? "Tidak Ada Data"
                                                      : "No data",
                                                  style: GoogleFonts.inder(
                                                      color:
                                                          isDark ? base : home),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ]

                              // Kalo Kategori
                              else if (r == 2) ...[
                                Expanded(
                                    child: Column(
                                  children: [
                                    // Details
                                    Details(
                                        name: name,
                                        startDate: startDate,
                                        endDate: endDate,
                                        totalExpense: totalExpense,
                                        totalIncome: totalIncome,
                                        dailyAverage: dailyAverage),

                                    // ---------------------------> Mapping data Expense <---------------------------------------
                                    Text(
                                      (lang == 0)
                                          ? "Pengeluaran Berdasarkan Kategori"
                                          : "Expense by Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? base : Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: FutureBuilder<
                                              List<Map<String, Object>?>>(
                                          future:
                                              database.getExpCatNameByRekaps(
                                                  dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            final expenseCategory =
                                                snapshot.data;
                                            print(
                                                "isi  category $expenseCategory");
                                            // final expenseCategory =
                                            //     snapshot.data![1];

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primary));
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var expenseNames =
                                                            snapshot.data![
                                                                index]!["name"];
                                                        var expenseAmount =
                                                            snapshot.data![
                                                                    index]![
                                                                "totalAmount"];
                                                        print(
                                                            "xpense $expenseNames");
                                                        print(
                                                            "amount $expenseAmount");

                                                        // Convert to Rp
                                                        var amountString =
                                                            (NumberFormat
                                                                    .currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(expenseAmount))
                                                                .replaceAll(
                                                                    'IDR', '');

                                                        // Kalo Pengeluaran
                                                        return SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    expenseNames
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Nama kategori income
                                                                  Text(
                                                                    "Rp." +
                                                                        amountString,
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Total Expense
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 7),
                                                              LinearPercentIndicator(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.85,
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(
                                                                        16),
                                                                lineHeight: 8.0,
                                                                percent:
                                                                    calculatePercentage(
                                                                  (expenseAmount
                                                                          as num)
                                                                      .toDouble(),
                                                                  totalExpense
                                                                      .toDouble(),
                                                                ), // Ganti nilai persentase sesuai kebutuhan
                                                                progressColor:
                                                                    Colors.red,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                              }
                                              return Text(
                                                (lang == 0)
                                                    ? "Belum ada pengeluaran"
                                                    : "No expenses yet",
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              );
                                            }
                                          }),
                                    ),

                                    SizedBox(height: 5),
                                    Text(
                                      (lang == 0)
                                          ? "Pemasukan Berdasarkan Kategori"
                                          : "Income by Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? base : Colors.black),
                                    ),
                                    SizedBox(height: 10),

                                    // ---------------------------> Mapping data Income <---------------------------------------
                                    Expanded(
                                      child: FutureBuilder<
                                              List<Map<String, Object>?>>(
                                          future:
                                              database.getIncCatNameByRekaps(
                                                  dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            final incomeCategory =
                                                snapshot.data;
                                            print(
                                                "isi  category $incomeCategory");
                                            // final expenseCategory =
                                            //     snapshot.data![1];

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primary));
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var incomeNames =
                                                            snapshot.data![
                                                                index]!["name"];
                                                        var incomeAmount =
                                                            snapshot.data![
                                                                    index]![
                                                                "totalAmount"];

                                                        // Convert to Rp
                                                        var amountString =
                                                            (NumberFormat
                                                                    .currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(incomeAmount))
                                                                .replaceAll(
                                                                    'IDR', '');

                                                        // Kalo Pengeluaran
                                                        return SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    incomeNames
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Nama kategori income
                                                                  Text(
                                                                    "Rp." +
                                                                        amountString,
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Total Income
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 7),
                                                              LinearPercentIndicator(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.85,
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(
                                                                        16),
                                                                lineHeight: 8.0,
                                                                percent:
                                                                    calculatePercentage(
                                                                  (incomeAmount
                                                                          as num)
                                                                      .toDouble(),
                                                                  totalIncome
                                                                      .toDouble(),
                                                                ), // Ganti nilai persentase sesuai kebutuhan
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                              }
                                              return Text(
                                                (lang == 0)
                                                    ? "Belum ada pemasukan"
                                                    : "No incomes yet",
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              );
                                            }
                                          }),
                                    ),

                                    SizedBox(height: 25),
                                  ],
                                ))

                                // Kalo Transaksi
                              ] else if (r == 3) ...[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: Column(
                                      children: [
                                        Details(
                                            name: name,
                                            startDate: startDate,
                                            endDate: endDate,
                                            totalExpense: totalExpense,
                                            totalIncome: totalIncome,
                                            dailyAverage: dailyAverage),

                                        // ---------------------------> Mapping Transaction Name <---------------------------------------
                                        Expanded(
                                          child: StreamBuilder<
                                              List<TransactionWithCategory>>(
                                            stream:
                                                database.getTransactionByRekaps(
                                                    dbStartDate, dbEndDate),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(primary)),
                                                );
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final type = snapshot
                                                              .data![index]
                                                              .category
                                                              .type;
                                                          return SingleChildScrollView(
                                                            child: ListTile(
                                                              leading:
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: isDark
                                                                      ? card
                                                                      : base,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              35),
                                                                ),
                                                                child: (snapshot
                                                                            .data![
                                                                                index]
                                                                            .transaction
                                                                            .image !=
                                                                        null)
                                                                    ? Image
                                                                        .memory(
                                                                        snapshot.data![index].transaction.image ??
                                                                            Uint8List(0),
                                                                        // width: 80,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            50,
                                                                      )
                                                                    : Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromRGBO(0, 0, 0, 0.1)),
                                                                            child: snapshot.data![index].category.type == 2
                                                                                ? Icon(
                                                                                    Icons.upload_rounded,
                                                                                    color: Colors.red,
                                                                                    size: 40,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.download_rounded,
                                                                                    color: Colors.green,
                                                                                    size: 40,
                                                                                  ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        snapshot
                                                                            .data![index]
                                                                            .transaction
                                                                            .name,
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? base
                                                                                : Colors.black),
                                                                      ),
                                                                      Text(
                                                                        'Rp. ' +
                                                                            (NumberFormat.currency(
                                                                              locale: 'id',
                                                                              decimalDigits: 0,
                                                                            ).format(
                                                                              snapshot.data![index].transaction.amount,
                                                                            )).replaceAll('IDR', ''),
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? base
                                                                                : Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      LinearPercentIndicator(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5,
                                                                        barRadius: const Radius
                                                                            .circular(
                                                                            16),
                                                                        lineHeight:
                                                                            7.0,
                                                                        percent:
                                                                            calculatePercentage(
                                                                          (snapshot.data![index].transaction.amount)
                                                                              .toDouble(),
                                                                          (type == 1)
                                                                              ? totalIncome.toDouble()
                                                                              : totalExpense.toDouble(),
                                                                        ), // Ganti nilai persentase sesuai kebutuhan
                                                                        progressColor: (type ==
                                                                                1)
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                      ),
                                                                      IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.arrow_forward_ios_sharp,
                                                                            color:
                                                                                primary,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: ((context) => TransactionPage(
                                                                                      transactionWithCategory: snapshot.data![index],
                                                                                    )),
                                                                              ),
                                                                            );
                                                                          })
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        (lang == 0)
                                                            ? 'Tidak ada data'
                                                            : "No data",
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? base
                                                              : home,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      (lang == 0)
                                                          ? 'Tidak ada data'
                                                          : "No data",
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? base
                                                            : home,
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
                            ],
                          ),
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
      bottomNavigationBar: BottomAppBar(
        color: isDark ? dialog : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(selectedDate: DateTime.now()),
                      ),
                      (route) => false);
                },
                icon: Icon(
                  Icons.home,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),
                      (route) => false);
                },
                icon: Icon(
                  Icons.list,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => RekapPage(
                        r: 1,
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.bar_chart,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
