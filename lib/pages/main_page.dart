import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/gallery_pages.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'package:sisaku/pages/setting_page.dart';
import 'package:sisaku/pages/transaction_page.dart';
import 'package:sisaku/colors.dart';

class MainPage extends StatefulWidget {
  final int params;

  final String title;

  const MainPage({super.key, required this.params, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;
  late String currentTitle;
  late int type;

  @override
  void initState() {
    updateView(widget.params, widget.title, DateTime.now());
    updateType(1);
    super.initState();
  }

  void updateType(int index) {
    setState(() {
      type = index;
    });
  }

  int getType() {
    return type;
  }

  void updateView(int index, String title, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(date),
        );
      }
      currentTitle = title;
      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        CategoryPage(),
        RekapPage(),
        SettingPage(),
        TransactionPage(transactionWithCategory: null),
        GalleryPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              locale: 'id',
              backButton: false,
              accent: primary,
              firstDate: DateTime.now().subtract(
                Duration(days: 140),
              ),
              lastDate: DateTime.now(),
              onDateChanged: (value) {
                print('Selected date ' + value.toString());
                selectedDate = value;
                updateView(0, "Home", selectedDate);
              },
            )
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
              child: Container(
                color: primary,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  // Kalo Kategori dan Gallery Page dipilih
                  child: (currentIndex == 1 ||
                          currentIndex == 4 ||
                          currentIndex == 5)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 0, 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: (type == 1)
                                                    ? primary
                                                    : base,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(16),
                                                  topLeft: Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: (type == 1)
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
                                                color: (type == 2)
                                                    ? primary
                                                    : base,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      updateType(2);
                                                    },
                                                    child: Text(
                                                      "Pengeluaran",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: (type == 2)
                                                            ? base
                                                            : primary,
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
                        )
                      : Text(
                          currentTitle,
                          style: GoogleFonts.montserrat(
                            fontSize: 23,
                            color: base,
                          ),
                        ),
                ),
              ),
            ),
      body: _children[currentIndex],
      backgroundColor: primary,
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => TransactionPage(),
            //   ),
            // );
            updateView(4, "Tambah Transaksi", DateTime.now());
          },
          backgroundColor: primary,
          child: Icon(
            Icons.add,
            color: base,
          ),
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
                  updateView(0, "Home", DateTime.now());
                },
                icon: Icon(
                  Icons.home,
                  color: (currentIndex == 0) ? primary : Colors.black,
                ),
              ),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  updateView(1, "Kategori", null);
                },
                icon: Icon(
                  Icons.list,
                  color: (currentIndex == 1) ? primary : Colors.black,
                ),
              ),
            ),

            Expanded(
              child: IconButton(
                onPressed: () {
                  updateView(2, "Rekap", null);
                },
                icon: Icon(
                  Icons.bar_chart,
                  color: (currentIndex == 2) ? primary : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  updateView(3, "Pengaturan", null);
                },
                icon: Icon(
                  Icons.settings,
                  color: (currentIndex == 3) ? primary : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
