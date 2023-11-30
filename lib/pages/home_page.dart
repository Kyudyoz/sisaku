import 'dart:typed_data';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisaku/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sisaku/models/database.dart';
import 'package:sisaku/models/transaction_with_category.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'package:sisaku/pages/setting_page.dart';
import 'package:sisaku/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  int totalAmount1 = 0;
  int totalAmount2 = 0;
  int rest = 0;
  int result1 = 0;
  int result2 = 0;
  late DateTime selectedDate;
  void initState() {
    updateView(DateTime.now());
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    final type1 = 1;
    final type1Count = await database.countType(type1);

    if (type1Count > 0) {
      result1 = await database.getTotalAmountForTypeAndDate(type1);
    }

    final type2 = 2;
    final type2Count = await database.countType(type2);

    if (type2Count > 0) {
      result2 = await database.getTotalAmountForTypeAndDate(type2);
    }

    setState(() {
      totalAmount1 = result1;
      totalAmount2 = result2;
      rest = totalAmount1 - totalAmount2;
    });
  }

  void updateView(DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(date),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        locale: 'id',
        backButton: false,
        accent: primary,
        firstDate: DateTime.now().subtract(
          Duration(days: 140),
        ),
        lastDate: DateTime.now(),
        onDateChanged: (value) {
          print('Selected date : ' + value.toString());
          selectedDate = value;
          updateView(selectedDate);
        },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 20, 16, 5),
                        child: Text(
                          'Sisa Uang Kamu : Rp. ' +
                              (NumberFormat.currency(
                                locale: 'id',
                                decimalDigits: 0,
                              ).format(
                                rest,
                              )).replaceAll('IDR', ''),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: home,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.download_outlined,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Pemasukan',
                                        style: GoogleFonts.montserrat(
                                          color: base,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Rp. ' +
                                            (NumberFormat.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                            ).format(
                                              totalAmount1,
                                            )).replaceAll('IDR', ''),
                                        style: GoogleFonts.montserrat(
                                          color: base,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.upload_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Pengeluaran',
                                        style: GoogleFonts.montserrat(
                                          color: base,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Rp. ' +
                                            (NumberFormat.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                            ).format(
                                              totalAmount2,
                                            )).replaceAll('IDR', ''),
                                        style: GoogleFonts.montserrat(
                                          color: base,
                                          fontSize: 14,
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

                      //text transaksi
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaksi',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RekapPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Semua',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: StreamBuilder<List<TransactionWithCategory>>(
                          stream: database.getTransactionByDate(selectedDate),
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
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: SingleChildScrollView(
                                            child: Card(
                                              elevation: 10,
                                              child: ListTile(
                                                leading: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: (snapshot
                                                              .data![index]
                                                              .transaction
                                                              .image !=
                                                          null)
                                                      ? Image.memory(
                                                          snapshot
                                                                  .data![index]
                                                                  .transaction
                                                                  .image ??
                                                              Uint8List(0),
                                                          width: 80,
                                                        )
                                                      : Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 8,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .question_mark,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                                title: Text(
                                                  'Rp. ' +
                                                      (NumberFormat.currency(
                                                        locale: 'id',
                                                        decimalDigits: 0,
                                                      ).format(
                                                        snapshot.data![index]
                                                            .transaction.amount,
                                                      )).replaceAll('IDR', ''),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data![index].category
                                                          .name +
                                                      ' (' +
                                                      snapshot.data![index]
                                                          .transaction.name +
                                                      ') ',
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shadowColor:
                                                                    Colors.red[
                                                                        50],
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            'Yakin ingin Hapus?',
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                'Batal',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () async {
                                                                                // Navigator.of(
                                                                                //         context,
                                                                                //         rootNavigator:
                                                                                //             true)
                                                                                //     .pop();
                                                                                await database.deleteTransactionRepo(snapshot.data![index].transaction.id);
                                                                                // Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                Navigator.of(context).pushReplacement(
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => HomePage(),
                                                                                  ),
                                                                                );

                                                                                setState(() {});
                                                                              },
                                                                              child: Text(
                                                                                'Ya',
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
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.edit),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: ((context) =>
                                                                TransactionPage(
                                                                  transactionWithCategory:
                                                                      snapshot.data![
                                                                          index],
                                                                )),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                    child: Text('Tidak ada data'),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Text('Tidak ada data'),
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
            ),
          ],
        ),
      ),
      backgroundColor: primary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  TransactionPage(transactionWithCategory: null),
            ),
          );
        },
        backgroundColor: primary,
        child: Icon(
          Icons.add,
          color: base,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  color: primary,
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
