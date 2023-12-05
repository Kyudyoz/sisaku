//add+edit
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:sisaku/colors.dart';
import 'setting_page.dart';

import 'package:sisaku/pages/rekap_page.dart';

import 'package:sisaku/models/database.dart';

class AddEditRekap extends StatefulWidget {
  final Rekap? rekap;
  const AddEditRekap({super.key, required this.rekap});

  @override
  State<AddEditRekap> createState() => _AddEditRekapState();
}

class _AddEditRekapState extends State<AddEditRekap> {
  late int type;
  final AppDb database = AppDb();

  // Form Controller
  TextEditingController namaRekapController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // Variabel
  String dbStartDate = '';
  String dbEndDate = '';

  void updateRekapView(Rekap rekap) {
    namaRekapController.text = rekap.name.toString();
    startDateController.text =
        DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    dbStartDate = DateFormat('yyyy-MM-dd').format(rekap.startDate);
    endDateController.text = DateFormat('dd-MMMM-yyyy').format(rekap.endDate);
    dbEndDate = DateFormat('yyyy-MM-dd').format(rekap.endDate);
  }

//Future Function CRUD
  Future insert(String namaRekap, DateTime startDate, DateTime endDate) async {
    return await database.insertRekap(namaRekap, startDate, endDate);
  }

  Future update(
      int id, String namaRekap, DateTime startDate, DateTime endDate) async {
    return await database.updateRekap(id, namaRekap, startDate, endDate);
  }

  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: primary,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 27,
                    )),
                SizedBox(
                  width: 80,
                ),
                Text(
                  "Tambah Rekap",
                  style: GoogleFonts.inder(
                    fontSize: 18,
                    color: base,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          controller: namaRekapController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Deskripsi',
                          ),
                        ),
                      ),

                      // =>Start Date
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: startDateController,
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
                              String formattedDate = DateFormat('dd-MMMM-yyyy')
                                  .format(pickedDate!);
                              startDateController.text = formattedDate;
                              String data =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dbStartDate = data;
                              });
                            }
                          },
                        ),
                      ),

                      // EndDate
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: endDateController,
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
                              String formattedDate = DateFormat('dd-MMMM-yyyy')
                                  .format(pickedDate!);
                              endDateController.text = formattedDate;
                              String data =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dbEndDate = data;
                              });
                            }
                          },
                        ),
                      ),

                      // Button Save
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton(
                          onPressed: () async {
                            print("dbStart Date" + dbStartDate);
                            print("dbEnd Date" + dbEndDate);

                            // Memproses CRUD
                            (widget.rekap == null)
                                ? await insert(
                                    namaRekapController.text,
                                    DateTime.parse(dbStartDate),
                                    DateTime.parse(dbEndDate),
                                  )
                                : await update(
                                    widget.rekap!.id,
                                    namaRekapController.text,
                                    DateTime.parse(dbStartDate),
                                    DateTime.parse(dbEndDate),
                                  );

                            print("CRUD Berhasil ??");
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RekapPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Simpan",
                            style: GoogleFonts.inder(
                              color: base,
                              fontSize: 15,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                                MaterialStateProperty.all<Color>(primary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]))));
  }
}
