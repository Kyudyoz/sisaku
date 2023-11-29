import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:sisaku/pages/main_page.dart';
import 'package:sisaku/widgets/image_input.dart';
import 'package:sisaku/colors.dart';
import 'dart:io';
import 'package:sisaku/models/database.dart';
import 'package:sisaku/models/transaction_with_category.dart';

import 'main_page.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({
    super.key,
    required this.transactionWithCategory,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  late int type;
  final AppDb database = AppDb();

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  Category? selectedCategory;
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  String dbDate = '';
  // List<String> list = ["Makan", "Jajan", "Transportasi"];
  // late String dropdownValue = list.first;

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    deskripsiController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat('dd-MMMM-yyyy')
        .format(transactionWithCategory.transaction.transaction_date);
    dbDate = DateFormat('yyyy-MM-dd')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = transactionWithCategory.category;
  }

  Future insert(
      int amount, DateTime date, String deskripsi, int categoryId) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            name: deskripsi,
            category_id: categoryId,
            transaction_date: date,
            amount: amount,
            createdAt: now,
            updatedAt: now,
          ),
        );
    print(row.toString());
  }

  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String deskripsi) async {
    return await database.updateTransactionRepo(
      transactionId,
      amount,
      categoryId,
      transactionDate,
      deskripsi,
    );
  }

  // Parameter untuk ImageInput
  File? savedImage;
  void savedImages(File image) {
    savedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: TextFormField(
                            controller: deskripsiController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Deskripsi',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Jumlah Uang',
                            ),
                          ),
                        ),

                        // SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: 'Pilih Tanggal',
                              suffixIcon: Icon(
                                Icons.calendar_month_rounded,
                                color: primary,
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2099),
                              );

                              if (pickedDate != Null) {
                                String formattedDate =
                                    DateFormat('dd-MMMM-yyyy')
                                        .format(pickedDate!);
                                dateController.text = formattedDate;
                                String data =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  dbDate = data;
                                });
                              }
                            },
                          ),
                        ),

                        FutureBuilder<List<Category>>(
                          future: getAllCategory(type),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: DropdownButtonFormField<Category>(
                                      decoration: InputDecoration(
                                        hintText: 'Pilih Kategori',
                                      ),
                                      isExpanded: true,
                                      value: selectedCategory,
                                      icon: Icon(
                                        Icons.arrow_downward,
                                      ),
                                      items:
                                          snapshot.data!.map((Category item) {
                                        return DropdownMenuItem<Category>(
                                          value: item,
                                          child: Text(item.name),
                                        );
                                      }).toList(),
                                      onChanged: (Category? value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      },
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24.0, horizontal: 18.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Kategori tidak ada'),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                // DetailPage adalah halaman yang dituju
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(
                                                          params: 1,
                                                          title: "Kategori",
                                                        )),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: base,
                                            ),
                                            label: Text(
                                              'Tambah kategori',
                                              style: GoogleFonts.montserrat(
                                                  color: base),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.cyan[600]!),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Center(
                                    child: Text('Kategori tidak ada'),
                                  ),
                                );
                              }
                            }
                          },
                        ),

                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gambar (opsional)",
                                style: GoogleFonts.montserrat(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageInput(imagesaveat: savedImages),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      (widget.transactionWithCategory == null)
                                          ? insert(
                                              int.parse(amountController.text),
                                              DateTime.parse(dbDate),
                                              deskripsiController.text,
                                              selectedCategory!.id,
                                            )
                                          : await update(
                                              widget.transactionWithCategory!
                                                  .transaction.id,
                                              int.parse(amountController.text),
                                              selectedCategory!.id,
                                              DateTime.parse(dbDate),
                                              deskripsiController.text,
                                            );

                                      // Navigator.pop(context);
                                      await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainPage(
                                            params: 0,
                                            title: 'Home',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Simpan Transaksi',
                                      style: GoogleFonts.montserrat(
                                        color: base,
                                        fontSize: 15,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                                          MaterialStateProperty.all<Color>(
                                              primary),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
