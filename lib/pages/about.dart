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
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_sharp, color: base),
                ),
                Text(
                  (lang == 0) ? "Tentang Pengembang" : 'About Developer',
                  style: GoogleFonts.inder(
                    fontSize: 23,
                    color: base,
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
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Muhammad Iqbal Firdaus',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Programmer(Fullstack)',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/images.png'),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Sabrian Maulana',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Programmer(Fullstack)',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/zainul.png'),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Muhammad Zainul Ikhsan',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Programmer(Fullstack)',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/fathan.png'),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Abdurrahman Fathan Muharrik',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Designer',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/ikvi.png'),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Ikvi Akmal Rivaldi',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Designer',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/images.png'),
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
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
                                                        (lang == 0)
                                                            ? 'Nama : '
                                                            : 'Name : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Asal : '
                                                            : 'University : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Prodi : '
                                                            : 'Major : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Role : ',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Selly Clarisa Valentin Panggabean',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Universitas Jambi'
                                                            : 'Jambi University',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? 'Sistem Informasi'
                                                            : 'Information System',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Designer',
                                                        style:
                                                            GoogleFonts.inder(
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
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
