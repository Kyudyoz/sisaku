import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sisaku/colors.dart';
import 'package:sisaku/models/database.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AppDb database = AppDb();

  @override
  void initState() {
    super.initState();

    loadData();
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
              "Pengaturan",
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
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(45),
                        child: Column(
                          children: [
                            // Remove Ads
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.price_check_rounded,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Hapus Iklan"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),

                            // Backup and Restore Data
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.restore_page,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Backup dan Restore Data"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Icon(
                                  Icons.delete_rounded,
                                  color: base,
                                  size: 27,
                                ),
                              ),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Hapus Data"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shadowColor: Colors.red[50],
                                            content: SingleChildScrollView(
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Yakin ingin Hapus?',
                                                        style:
                                                            GoogleFonts.inder(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Batal',
                                                            style: GoogleFonts
                                                                .inder(
                                                              color: home,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      primary)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');
                                                            database
                                                                .deleteAll();
                                                            setState(() {
                                                              print(
                                                                "Berhasil Hapus Semua",
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Berhasil Hapus Semua Data',
                                                                      style: GoogleFonts.inder(
                                                                          color:
                                                                              base),
                                                                    ),
                                                                    backgroundColor:
                                                                        primary),
                                                              );
                                                            });
                                                          },
                                                          child: Text(
                                                            'Ya',
                                                            style: GoogleFonts
                                                                .inder(
                                                              color: base,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                  }),
                            ]),
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.brush_rounded,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Tema Warna"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Pilih Warna"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RadioListTile.adaptive(
                                                value: 0,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Default",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[0],
                                                selected: true,
                                              ),
                                              RadioListTile.adaptive(
                                                value: 1,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Magenta",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[1],
                                                selected: true,
                                              ),
                                              RadioListTile.adaptive(
                                                value: 2,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Green",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[2],
                                                selected: true,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ]),
                            SizedBox(height: 18),
                            // Remider Notification
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Icon(
                                            !isDark
                                                ? Icons.light_mode_rounded
                                                : Icons.dark_mode_rounded,
                                            color: base,
                                            size: 27,
                                          )),
                                      SizedBox(width: 20),
                                      TextButton(
                                          child: Text("Dark Mode"),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black),
                                          onPressed: () {
                                            setState(() {
                                              (isDark)
                                                  ? isDark = false
                                                  : isDark = true;
                                              print(isDark);
                                            });
                                            saveData();
                                          }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Switch(
                                        value: isDark,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isDark = value;

                                            print(isDark);
                                          });
                                          saveData();
                                        },
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Colors.white,
                                        activeTrackColor: primary,
                                      ),
                                    ],
                                  ),
                                ]),
                            SizedBox(height: 18),
                            // Language
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.language,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Bahasa"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 32),

                            // Sosmed
                            Center(
                              child: Column(
                                children: [
                                  Text("Ikuti Kami"),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/img/mdi_instagram.png"),
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Icon(
                                            Icons.facebook_sharp,
                                            color: base,
                                            size: 27,
                                          )),
                                      SizedBox(width: 20),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: ImageIcon(
                                          AssetImage("assets/img/twitter.png"),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
        color: isDark ? dialog : null,
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(),
                    ),
                  );
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RekapPage(
                        r: 1,
                      ),
                    ),
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
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

SharedPreferences? _sharedPreferences;

late int _kode = 0;
late bool isDark = false;

// Fungsi untuk menyimpan data ke `SharedPreferences`
void saveData() async {
  // Buat objek `SharedPreferences`
  _sharedPreferences = await SharedPreferences.getInstance();
  // Simpan data ke `SharedPreferences`
  _sharedPreferences?.setInt("kode", _kode);
  _sharedPreferences?.setBool("isDark", isDark);
}

// Fungsi untuk mengambil data dari `SharedPreferences`
void loadData() async {
  // Buat objek `SharedPreferences`
  _sharedPreferences = await SharedPreferences.getInstance();
  // Ambil data dari `SharedPreferences`
  _kode = _sharedPreferences?.getInt("kode") ?? 0;
  isDark = _sharedPreferences?.getBool("isDark") ?? false;
  print(isDark);
}

Color get primary => _getPrimary(_kode);

Color _getPrimary(int kode) {
  return defaultTheme[kode];
}

const defaultTheme = [
  Color.fromARGB(255, 0, 171, 194),
  Color.fromARGB(255, 188, 43, 216),
  Color.fromARGB(255, 62, 166, 106),
];

const secondary = Color.fromARGB(255, 151, 221, 230);
const base = Color.fromARGB(255, 243, 243, 243);
const home = Color.fromARGB(162, 0, 35, 39);

const background = Color.fromRGBO(24, 24, 24, 1);
const card = Color.fromRGBO(61, 61, 61, 1);
const dialog = Color.fromRGBO(33, 33, 33, 1);
