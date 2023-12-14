import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'setting_page.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
              (lang == 0) ? "Tentang Pengembang" : 'About Developer',
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
                  color: isDark ? background : base,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/img/iqbal.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            thickness: 0.5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Nama : ',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Asal : ',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Prodi : ',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Role : ',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Muhammad Iqbal Firdaus',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Universitas Jambi',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Sistem Informasi',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Programmer',
                                                    style: GoogleFonts.inder(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
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
