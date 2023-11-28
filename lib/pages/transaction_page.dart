import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:sisaku/pages/main_page.dart';
import 'package:sisaku/widgets/image_input.dart';
import 'package:sisaku/colors.dart';
import 'dart:io';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    super.key,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  String dbDate = '';
  List<String> list = ["Makan", "Jajan", "Transportasi"];
  late String dropdownValue = list.first;

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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Pilih Kategori',
                            ),
                            isExpanded: true,
                            value: dropdownValue,
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: primary,
                              ),
                            ),
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {},
                          ),
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
                                    onPressed: () {
                                      print("yes");
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
