import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sisaku/colors.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
              style: GoogleFonts.montserrat(
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
                            // Restore Purchased Items
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.replay_outlined,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Restore Purchased Items"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),

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
                                  child: Text("Remove Ads"),
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
                                  child: Text("Backup and Restore Data"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),

                            // Clear Data
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.delete_rounded,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Clear Data"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),

                            // Remider Notification
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.notifications,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text("Reminder"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 18),

                            // Theme Color
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
                                  child: Text("Theme Color"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
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
                                  child: Text("Language"),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {}),
                            ]),
                            SizedBox(height: 32),

                            // Sosmed
                            Center(
                              child: Column(
                                children: [
                                  Text("Follow Us"),
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
                            )
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
