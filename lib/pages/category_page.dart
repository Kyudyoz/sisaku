import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:sisaku/colors.dart';
import 'package:sisaku/models/database.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'package:sisaku/pages/setting_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late int type;

  void initState() {
    updateType(1);
    super.initState();
  }

  void updateType(int index) {
    setState(() {
      type = index;
    });
    print("tipe sekarang : " + type.toString());
  }

  final AppDb database = AppDb();

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print(row);
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  TextEditingController categoryNameController = TextEditingController();
  // Dialog
  void openDialog(Category? category) {
    String text = 'Tambah';
    if (category != null) {
      categoryNameController.text = category.name;
      text = 'Edit';
    }
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDark ? dialog : Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      (type == 2)
                          ? '$text Kategori Pengeluaran'
                          : '$text Kategori Pemasukan',
                      style: GoogleFonts.inder(
                          fontSize: 18, color: isDark ? base : home),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black),
                            controller: categoryNameController,
                            cursorColor: primary,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama kategori tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: isDark ? true : false,
                              fillColor: isDark ? card : null,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: isDark ? base : Colors.black,
                                ),
                              ),
                              labelText: "Nama Kategori",
                              labelStyle: TextStyle(
                                color: isDark ? base : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(primary),
                              shape: MaterialStatePropertyAll(
                                ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (category == null &&
                                    categoryNameController.text != '') {
                                  insert(
                                    categoryNameController.text,
                                    type,
                                  );
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  setState(() {});
                                  categoryNameController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Berhasil Tambah Kategori',
                                        style: GoogleFonts.inder(color: base),
                                      ),
                                      backgroundColor: primary,
                                    ),
                                  );
                                } else {
                                  if (category != null &&
                                      categoryNameController.text != '') {
                                    update(
                                      category.id,
                                      categoryNameController.text,
                                    );
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                    setState(() {});
                                    categoryNameController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Berhasil Edit Kategori',
                                          style: GoogleFonts.inder(color: base),
                                        ),
                                        backgroundColor: primary,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(
                              'Simpan',
                              style: GoogleFonts.inder(
                                color: base,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori",
                  style: GoogleFonts.inder(
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
                          color: isDark ? background : base,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (type == 1) ? primary : base,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      topLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          style: GoogleFonts.inder(
                                            color: (type == 1) ? base : primary,
                                            fontWeight: (type == 1) ? FontWeight.bold : FontWeight.normal
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
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (type == 2) ? primary : base,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          updateType(2);
                                        },
                                        child: Text(
                                          "Pengeluaran",
                                          style: GoogleFonts.inder(
                                            color: (type == 2) ? base : primary,
                                            fontWeight: (type == 2) ? FontWeight.bold : FontWeight.normal
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
                child: SafeArea(
                  // mulai dari sini coyy

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          top: 10,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(primary),
                            shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            openDialog(null);
                            categoryNameController.clear();
                          },
                          child: Text(
                            'Tambah',
                            style: GoogleFonts.inder(
                              color: base,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Category>>(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(primary)),
                              );
                            } else {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Card(
                                            color: isDark ? card : base,
                                            elevation: 10,
                                            child: ListTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color:
                                                          isDark ? base : home,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  isDark
                                                                      ? dialog
                                                                      : Colors
                                                                          .white,
                                                              shadowColor:
                                                                  Colors
                                                                      .red[50],
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Center(
                                                                  child: Column(
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'Yakin ingin Hapus?',
                                                                          style:
                                                                              GoogleFonts.inder(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: isDark
                                                                                ? base
                                                                                : home,
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
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Batal',
                                                                              style: GoogleFonts.inder(
                                                                                color: isDark ? base : home,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(primary),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                              database.deleteCategoryAndTransactionsRepo(snapshot.data![index].id);
                                                                              setState(() {
                                                                                print("Berhasil Hapus");
                                                                              });
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text(
                                                                                      'Berhasil Hapus Kategori',
                                                                                      style: GoogleFonts.inder(color: base),
                                                                                    ),
                                                                                    backgroundColor: primary),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
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
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color:
                                                          isDark ? base : home,
                                                    ),
                                                    onPressed: () {
                                                      openDialog(snapshot
                                                          .data![index]);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              leading: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: (type == 2)
                                                    ? Icon(Icons.upload,
                                                        color: Colors
                                                            .redAccent[400])
                                                    : Icon(
                                                        Icons.download,
                                                        color: Colors
                                                            .greenAccent[400],
                                                      ),
                                              ),
                                              title: Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Data tidak ada',
                                      style: TextStyle(
                                        color: isDark ? base : home,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Text(
                                    'Data tidak ada',
                                    style: TextStyle(
                                      color: isDark ? base : home,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          future: getAllCategory(type),
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
                  color: primary,
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
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
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
