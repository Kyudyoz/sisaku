import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:open_document/my_files/init.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sisaku/pages/category_page.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/pages/rekap_page.dart';
import 'package:sisaku/pages/setting_page.dart';
import 'package:sisaku/models/database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sisaku/pages/transaction_page.dart';
import 'package:sisaku/widgets/details.dart';
import '../models/transaction_with_category.dart';
import 'package:excel/excel.dart';
// import 'package:open_document/open_document.dart';


class DetailRekap extends StatefulWidget {
  const DetailRekap({super.key, required this.rekap});
  final Rekap? rekap;

  @override
  State<DetailRekap> createState() => _DetailRekapsStat();
}

class _DetailRekapsStat extends State<DetailRekap>
    with SingleTickerProviderStateMixin {
  final AppDb database = AppDb();
  late int r;

  // Data Detail Rekap dari Rekap yang dipilih
  late int id;
  late String name;
  late String startDate;
  late String endDate;
  late var dbStartDate;
  late var dbEndDate;
  late var totalExpense;
  late var totalIncome;
  late var averageIncome;
  late var averageExpense;
  late int totalTransactions;
  late var balance;
  late bool isMonthly;
  late double dailyAverage;

  late String filePath;
  // Untuk dapetin categoi
  late var getCategory;
  // Tab
  late TabController _tabController;

  final _selectedColor = primary;
  // final _unselectedColor = base;

  final _tabs = [
    Tab(text: (lang == 0) ? 'Grafik' : "Chart"),
    Tab(text: (lang == 0) ? 'Kategori' : "Category"),
    Tab(text: (lang == 0) ? 'Nama' : "Name"),
  ];
  late bool isUpdate = false;

  late Map<String, double> _allTransactionPieChart = {};
  late Map<String, double> _pieChartIncExp = {};
  late Map<String, double> _pieChartIncName = {};
  late Map<String, double> _pieChartExpName = {};

  // final _iconTabs = const [
  //   Tab(icon: Icon(Icons.home)),
  //   Tab(icon: Icon(Icons.search)),
  //   Tab(icon: Icon(Icons.settings)),
  // ];

  Future<void> _loadData() async {
    setState(() {});
  }

  void updateRekapView(Rekap rekap) {
    id = rekap.id;
    name = rekap.name;
    print("Ini startDate :" + rekap.startDate.toString());

    startDate = DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    endDate = DateFormat('dd-MMMM-yyyy').format(rekap.endDate);

    // Untuk Query
    dbStartDate = rekap.startDate;
    dbEndDate = rekap.endDate;
    totalTransactions = rekap.totalTransactions!;
    totalExpense = rekap.totalExpense;
    totalIncome = rekap.totalIncome;
    averageIncome = rekap.totalIncome;
    averageExpense = rekap.totalExpense;
    balance = rekap.sisa;
    isMonthly = rekap.isMonthly;
    print('ini id $id');
  }

//  getCategoryNameByRekaps

  double getDailyAverage(int totalExpense, int totalIncome) {
    dailyAverage = (totalExpense + totalIncome) / totalTransactions;
    return dailyAverage;
  }

  void updateR(int index) {
    setState(() {
      r = index + 1;
    });
  }

  // Kalkulasi persen berdasarkan kategori
  double calculatePercentage(double categoryAmount, double totalAmount) {
    if (totalAmount > 0) {
      return categoryAmount / totalAmount;
    } else {
      return 0.0;
    }
  }

  double totalExpenseAmounts = 0;
  double totalIncomeAmounts = 0;

  // Get All transaction for Piechart
  Future<Map<String, double>> getRekapType(DateTime start, DateTime end) async {
    final Map<String, double> dataMap = await database.getRekapIncExpPieChart(start, end);
    return dataMap;
  }

  // Get Income Name for Piechart
  Future<Map<String, double>> getIncNamePieChart(DateTime start, DateTime end) async {
    final Map<String, double> dataMap = await database.getRekapIncPieChart(start, end);
    return dataMap;
  }

  // Get Expense for Piechart 
  Future<Map<String, double>> getExpNamePieChart(DateTime start, DateTime end) async {
    final Map<String, double> dataMap = await database.getRekapExpPieChart(start, end);
    return dataMap;
  }

 // Get All transaction for Piechart
  Future<Map<String, double>> getAllTransactions(DateTime start, DateTime end) async {
    final Map<String, double> dataMap = await database.getTransactionRekapPieChart(start, end);
    return dataMap;
  }

 

// =============================> load Data, Etc <=============================
  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();

  
    getDailyAverage(totalExpense, totalIncome);

    _tabController = TabController(length: 3, vsync: this);

    updateR(0);
    _loadData();


    getRekapType(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartIncExp = dataMap;
      });
    });
    
    getAllTransactions(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _allTransactionPieChart = dataMap;
      });
    });

    // Inc Name Piechart
    getIncNamePieChart(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartIncName = dataMap;
      });
    });

    // Exp Name Piechart
    getExpNamePieChart(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartExpName = dataMap;
      });
    });


  }

  Stream<List<Rekap>> getCustomRekaps() {
    return database.getCustomRekaps();
  }

  Stream<List<Rekap>> getMonthlyRekaps() {
    return database.getMonthlyRekaps();
  }

  Future<List<Rekap>> getSingleRekap(id) {
    return database.getSingleRekaps(id);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future update(int id, DateTime startDate, DateTime endDate) async {
    return await database.updateRekapAmount(id, startDate, endDate);
  }

  final rekap_detail = Rekap;

  void exportToExcel() async {
    Excel excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, name);


    Sheet sheet = excel[name];

        /*
    * sheetObject.updateCell(cell, value, { CellStyle (Optional)});
    * sheetObject created by calling - // Sheet sheetObject = excel['SheetName'];
    * cell can be identified with Cell Address or by 2D array having row and column Index;
    * Cell Style options are optional
    */

  

    

    CellStyle cellStyle = CellStyle(backgroundColorHex: '#1AFF1A', fontFamily :getFontFamily(FontFamily.Calibri));
    
    cellStyle.underline = Underline.Single; // or Underline.Double

    var a1 = sheet.cell(CellIndex.indexByString("A1"));
    a1.value = TextCellValue("Periode");

    var b2 = sheet.cell(CellIndex.indexByString("B2"));
    a1.value = TextCellValue( DateFormat('dd-MMMM-yyyy', (lang == 0) ? "id_ID" : null).format(dbStartDate).toString() + " ~ " +
                  DateFormat('dd-MMMM-yyyy', 'id_ID').format(dbEndDate));
    sheet.merge(CellIndex.indexByString("D1"), CellIndex.indexByString("I1"));
   
    // cell.value = null; // removing any value
    // cell.value = TextCellValue('Some Text');
    // cell.value = IntCellValue(8);
    // cell.value = BoolCellValue(true);
    // cell.value = DoubleCellValue(13.37);
    // cell.value = DateCellValue(year: 2023, month: 4, day: 20);
    // cell.value = TimeCellValue(hour: 20, minute: 15, second: 5, millisecond: ...);
    // cell.value = DateTimeCellValue(year: 2023, month: 4, day: 20, hour: 15, ...);
    // cell.cellStyle = cellStyle;


    
    // Save to Excel
  var fileBytes = excel.save();
  var directory = await getApplicationDocumentsDirectory();
  new Directory(directory.path+'/'+'dir').create(recursive: true)
  // The created directory is returned as a Future.
      .then((Directory directory) {
    print('Path of New Dir: '+directory.path);
    final new_dir = directory.path;
    filePath = new_dir;
     File(join('$new_dir/"nama".xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
  });

  print("Berhasil Export Excel Cuy");
   
        /*
    * sheetObject.merge(CellIndex starting_cell, CellIndex ending_cell, TextCellValue('customValue'));
    * sheetObject created by calling - // Sheet sheetObject = excel['SheetName'];
    * starting_cell and ending_cell can be identified with Cell Address or by 2D array having row and column Index;
    * customValue is optional
    */

    // sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('E4'), customValue: TextCellValue('Put this text after merge'));

    // // setting the number style
    // cell.cellStyle = (cell.cellStyle ?? CellStyle()).copyWith(

    //   /// for IntCellValue, DoubleCellValue and BoolCellValue use; 
    //   numberFormat: CustomNumericNumFormat('#,##0.00 \\m\\²'),

    //   /// for DateCellValue and DateTimeCellValue use:
    //   numberFormat: CustomDateTimeNumFormat('m/d/yy h:mm'),

    //   /// for TimeCellValue use:
    //   numberFormat: CustomDateTimeNumFormat('mm:ss'),

    //   /// a builtin format for dates
    //   numberFormat: NumFormat.standard_14,
      
    //   /// a builtin format that uses a red text color for negative numbers
    //   numberFormat: NumFormat.standard_38,

    //   // The numberFormat changes automatially if you set a CellValue that 
    //   // does not work with the numberFormat set previously. So in case you
    //   // want to set a new value, e.g. from a date to a decimal number, 
    //   // make sure you set the new value first and then your custom
    //   // numberFormat).
    // );


    // // printing cell-type
    // print('CellType: ' + switch(cell.value) {
    //   null => 'empty cell',
    //   TextCellValue() => 'text',
    //   FormulaCellValue() => 'formula',
    //   IntCellValue() => 'int',
    //   BoolCellValue() => 'bool',
    //   DoubleCellValue() => 'double',
    //   DateCellValue() => 'date',
    //   TimeCellValue => 'time',
    //   DateTimeCellValue => 'date with time',
    // });

    // ///
    // /// Inserting and removing column and rows

    // // insert column at index = 8
    // sheetObject.insertColumn(8);

    // // remove column at index = 18
    // sheetObject.removeColumn(18);

    // // insert row at index = 82
    // sheetObject.insertRow(82);

    // // remove row at index = 80
    // sheetObject.removeRow(80);

//  Future<String> downloadFile({String? filePath, String? url}) async {
//           // CancelToken cancelToken = CancelToken();
//         Dio dio = new Dio();
//           await dio.download(
//             url,
//             filePath,
//             onReceiveProgress: (count, total) {
//               debugPrint('---Download----Rec: $count, Total: $total');
//               setState(() {
//                 _platformVersion = ((count / total) * 100).toStringAsFixed(0) + "%";
//               });
//           },
//         );

//         return filePath;
//       }
//   void openExported() async {
//     final name = await OpenDocument.getNameFile(url: url);

//       final path = await OpenDocument.getPathDocument();

//       filePath = "$path/$name";

//       final isCheck = await OpenDocument.checkDocument(filePath: filePath);

//       try {
//         if (!isCheck) {
//           filePath = await downloadFile(filePath: "$filePath", url: url);
//         }

//       await OpenDocument.openDocument(filePath: filePath);

//       } on OpenDocumentException catch (e) {
//         debugPrint("ERROR: ${e.errorMessage}");
//         filePath = 'Failed to get platform version.';
//       }

     
//   }
  Future<File?> openExported() async {
    final result = await FilePicker.platform.pickFiles();

  }

  Future<File?> downloadFile(String url, String name) async {
    

    // try {
    //   final response = await Dio().get(
    //     url)
    // }
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          (lang == 0) ? "Detail Rekap" : "Recap Details",
          style: GoogleFonts.inder(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: base,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: base),
        ),
        actions: [
          TextButton(
            onPressed: () {
              exportToExcel();
               ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (lang == 0)
                                ? 'Berhasil Export Rekap'
                                : 'Export Report Success',
                            style: GoogleFonts.inder(
                                color: base),
                          ),
                          TextButton(onPressed: () {}, 
                          child: Row(children: [ 
                            Text("Open") ,SizedBox(width: 30), Icon(Icons.file_open, color: base)
                            ]))
                        ],
                      ),
                      backgroundColor: primary,
                    ),
                  );
            },
            child: Text(
              "Export",
              style: GoogleFonts.inder(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: base,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  color: (isDark) ? background : base,
                ),
                labelColor: (isDark) ? base : Colors.black87,
                unselectedLabelColor: Colors.white,
                tabs: _tabs,
                onTap: updateR,
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
                  color: (isDark) ? background : Colors.white,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Kalo Chart
                              if (r == 1) ...[
                                    Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // ===================================>All Inc Exp Data Map<===================================
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Text(
                                            (lang == 0)
                                                ? "Berdasarkan Tipe"
                                                : "By Type",
                                            style: GoogleFonts.inder(
                                              fontSize: 17,
                                              color:
                                                  isDark ? base : Colors.black,
                                            ),
                                          ),
                                        ),

                                        FutureBuilder<Map<String, double>>(
                                          future: getRekapType(dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(primary)),
                                              );
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 35),
                                                        child: PieChart(
                                                          dataMap:
                                                              _pieChartIncExp,
                                                          colorList: [
                                                            Colors.greenAccent,
                                                            Colors.redAccent
                                                          ],
                                                          chartRadius: 200,
                                                          legendOptions:
                                                              LegendOptions(
                                                            legendTextStyle:
                                                                GoogleFonts.inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                            legendPosition:
                                                                LegendPosition
                                                                    .right,
                                                          ),
                                                          chartValuesOptions:
                                                              ChartValuesOptions(
                                                            showChartValuesInPercentage:
                                                                true,
                                                            decimalPlaces: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Center();
                                                }
                                              } else {
                                                return Center();
                                              }
                                            }
                                          },
                                        ),

                                        // ===================================>All Transaction Inc Name Map<===================================
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 45),
                                          child: Text(
                                            (lang == 0)
                                                ? "Berdasarkan Kategori Pemasukan"
                                                : "By Income Category ",
                                            style: GoogleFonts.inder(
                                              fontSize: 17,
                                              color:
                                                  isDark ? base : Colors.black,
                                            ),
                                          ),
                                        ),

                                        FutureBuilder<Map<String, double>>(
                                          future: getIncNamePieChart(dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center();
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 35),
                                                        child: PieChart(
                                                          dataMap:
                                                              _pieChartIncName,
                                                          chartRadius: 200,
                                                          legendOptions:
                                                              LegendOptions(
                                                            legendTextStyle:
                                                                GoogleFonts.inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                            legendPosition:
                                                                LegendPosition
                                                                    .right,
                                                          ),
                                                          chartValuesOptions:
                                                              ChartValuesOptions(
                                                            showChartValuesInPercentage:
                                                                true,
                                                            decimalPlaces: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 35),
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Belum ada transaksi"
                                                              : "No transactions yet",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 85),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/img/tes.png',
                                                        width: 200,
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? "Tidak Ada Data"
                                                            : "No data",
                                                        style:
                                                            GoogleFonts.inder(
                                                                color: isDark
                                                                    ? base
                                                                    : home),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),

                                        // ===================================>All Transaction Expense Name Map<===================================
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 45),
                                          child: Text(
                                            (lang == 0)
                                                ? "Berdasarkan Kategori Pengeluaran"
                                                : "By Expense Category",
                                            style: GoogleFonts.inder(
                                              fontSize: 17,
                                              color:
                                                  isDark ? base : Colors.black,
                                            ),
                                          ),
                                        ),

                                        FutureBuilder<Map<String, double>>(
                                          future: getExpNamePieChart(dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center();
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 35),
                                                        child: PieChart(
                                                          dataMap:
                                                              _pieChartExpName,
                                                          chartRadius: 200,
                                                          legendOptions:
                                                              LegendOptions(
                                                            legendTextStyle:
                                                                GoogleFonts.inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                            legendPosition:
                                                                LegendPosition
                                                                    .right,
                                                          ),
                                                          chartValuesOptions:
                                                              ChartValuesOptions(
                                                            showChartValuesInPercentage:
                                                                true,
                                                            decimalPlaces: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 35),
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Belum ada transaksi"
                                                              : "No transactions yet",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 85),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/img/tes.png',
                                                        width: 200,
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? "Tidak Ada Data"
                                                            : "No data",
                                                        style:
                                                            GoogleFonts.inder(
                                                                color: isDark
                                                                    ? base
                                                                    : home),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),

                                        // ===================================>All Transaction Data Map<===================================
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 45),
                                          child: Text(
                                            (lang == 0)
                                                ? "Berdasarkan Semua Transaksi"
                                                : "By All Transaction",
                                            style: GoogleFonts.inder(
                                              fontSize: 17,
                                              color:
                                                  isDark ? base : Colors.black,
                                            ),
                                          ),
                                        ),

                                        FutureBuilder<Map<String, double>>(
                                          future: getAllTransactions(dbStartDate, dbEndDate),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center();
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 35),
                                                        child: PieChart(
                                                          dataMap: _allTransactionPieChart,
                                                          chartRadius: 200,
                                                          legendOptions:
                                                              LegendOptions(
                                                            legendTextStyle:
                                                                GoogleFonts.inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                            legendPosition:
                                                                LegendPosition
                                                                    .right,
                                                          ),
                                                          chartValuesOptions:
                                                              ChartValuesOptions(
                                                            showChartValuesInPercentage:
                                                                true,
                                                            decimalPlaces: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 35),
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Belum ada transaksi"
                                                              : "No transactions yet",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 85),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/img/tes.png',
                                                        width: 200,
                                                      ),
                                                      Text(
                                                        (lang == 0)
                                                            ? "Tidak Ada Data"
                                                            : "No data",
                                                        style:
                                                            GoogleFonts.inder(
                                                                color: isDark
                                                                    ? base
                                                                    : home),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
        
                             
                             
                              ]

                              // Kalo Kategori
                              else if (r == 2) ...[
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Details
                                      Details(
                                        name: name,
                                        startDate: dbStartDate,
                                        endDate: dbEndDate,
                                        totalExpense: totalExpense,
                                        totalIncome: totalIncome,
                                        dailyAverage: dailyAverage,
                                        isMonthly: isMonthly,
                                      ),

                                      // ---------------------------> Mapping data Expense <---------------------------------------
                                      Text(
                                        (lang == 0)
                                            ? "Pengeluaran Berdasarkan Kategori"
                                            : "Expense by Category",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? base : Colors.black),
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: FutureBuilder<
                                                List<Map<String, Object>?>>(
                                            future: database.getCatNameByRekaps(
                                                dbStartDate, dbEndDate, 2),
                                            builder: (context, snapshot) {
                                              final expenseCategory =
                                                  snapshot.data;
                                              print(
                                                  "isi  category $expenseCategory");
                                              // final expenseCategory =
                                              //     snapshot.data![1];

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(primary));
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length > 0) {
                                                    return ListView.builder(
                                                        itemCount:
                                                            snapshot.data!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var expenseNames =
                                                              snapshot.data![
                                                                  index]!["name"];
                                                          var expenseAmount =
                                                              snapshot.data![
                                                                      index]![
                                                                  "totalAmount"];
                                                          print(
                                                              "xpense $expenseNames");
                                                          print(
                                                              "amount $expenseAmount");

                                                          // Convert to Rp
                                                          var amountString =
                                                              (NumberFormat
                                                                      .currency(
                                                            locale: 'id',
                                                            decimalDigits: 0,
                                                          ).format(expenseAmount))
                                                                  .replaceAll(
                                                                      'IDR', '');

                                                          // Kalo Pengeluaran
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height: 20),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      expenseNames
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? base
                                                                              : home),
                                                                    ), // Nama kategori income
                                                                    Text(
                                                                      "Rp." +
                                                                          amountString,
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? base
                                                                              : home),
                                                                    ), // Total Expense
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
                                                                LinearPercentIndicator(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.87,
                                                                  barRadius:
                                                                      const Radius
                                                                          .circular(
                                                                          16),
                                                                  lineHeight: 8.0,
                                                                  percent:
                                                                      calculatePercentage(
                                                                    (expenseAmount
                                                                            as num)
                                                                        .toDouble(),
                                                                    totalExpense
                                                                        .toDouble(),
                                                                  ), // Ganti nilai persentase sesuai kebutuhan
                                                                  progressColor:
                                                                      Colors.red,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }
                                                }
                                                return Text(
                                                  (lang == 0)
                                                      ? "Belum ada pengeluaran"
                                                      : "No expenses yet",
                                                  style: TextStyle(
                                                      color:
                                                          isDark ? base : home),
                                                );
                                              }
                                            }),
                                      ),

                                      SizedBox(height: 5),
                                      Text(
                                        (lang == 0)
                                            ? "Pemasukan Berdasarkan Kategori"
                                            : "Income by Category",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? base : Colors.black),
                                      ),
                                      SizedBox(height: 10),

                                      // ---------------------------> Mapping data Income <---------------------------------------
                                      Expanded(
                                        child: FutureBuilder<
                                                List<Map<String, Object>?>>(
                                            future: database.getCatNameByRekaps(
                                                dbStartDate, dbEndDate, 1),
                                            builder: (context, snapshot) {
                                              final incomeCategory =
                                                  snapshot.data;
                                              print(
                                                  "tes isi  category $incomeCategory");
                                              // final expenseCategory =
                                              //     snapshot.data![1];

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(primary));
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length > 0) {
                                                    return ListView.builder(
                                                        itemCount:
                                                            snapshot.data!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var incomeNames =
                                                              snapshot.data![
                                                                  index]!["name"];
                                                          var incomeAmount =
                                                              snapshot.data![
                                                                      index]![
                                                                  "totalAmount"];

                                                          // Convert to Rp
                                                          var amountString =
                                                              (NumberFormat
                                                                      .currency(
                                                            locale: 'id',
                                                            decimalDigits: 0,
                                                          ).format(incomeAmount))
                                                                  .replaceAll(
                                                                      'IDR', '');

                                                          // Kalo Pengeluaran
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height: 20),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      incomeNames
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? base
                                                                              : home),
                                                                    ), // Nama kategori income
                                                                    Text(
                                                                      "Rp." +
                                                                          amountString,
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? base
                                                                              : home),
                                                                    ), // Total Income
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
                                                                LinearPercentIndicator(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.87,
                                                                  barRadius:
                                                                      const Radius
                                                                          .circular(
                                                                          16),
                                                                  lineHeight: 8.0,
                                                                  percent:
                                                                      calculatePercentage(
                                                                    (incomeAmount
                                                                            as num)
                                                                        .toDouble(),
                                                                    totalIncome
                                                                        .toDouble(),
                                                                  ), // Ganti nilai persentase sesuai kebutuhan
                                                                  progressColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }
                                                }
                                                return Text(
                                                  (lang == 0)
                                                      ? "Belum ada pemasukan"
                                                      : "No incomes yet",
                                                  style: TextStyle(
                                                      color:
                                                          isDark ? base : home),
                                                );
                                              }
                                            }),
                                      ),

                                      SizedBox(height: 25),
                                    ],
                                  ))

                                // Kalo Transaksi
                              ] else if (r == 3) ...[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: Column(
                                      children: [
                                        Details(
                                          name: name,
                                          startDate: dbStartDate,
                                          endDate: dbEndDate,
                                          totalExpense: totalExpense,
                                          totalIncome: totalIncome,
                                          dailyAverage: dailyAverage,
                                          isMonthly: isMonthly,
                                        ),

                                        // ---------------------------> Mapping Transaction Name <---------------------------------------
                                        Expanded(
                                          child: StreamBuilder<
                                              List<TransactionWithCategory>>(
                                            stream:
                                                database.getTransactionByRekaps(
                                                    dbStartDate, dbEndDate),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(primary)),
                                                );
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final type = snapshot
                                                              .data![index]
                                                              .category
                                                              .type;
                                                          return SingleChildScrollView(
                                                            child: ListTile(
                                                              leading:
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: isDark
                                                                      ? card
                                                                      : base,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              35),
                                                                ),
                                                                child: (snapshot
                                                                            .data![
                                                                                index]
                                                                            .transaction
                                                                            .image !=
                                                                        null)
                                                                    ? Image
                                                                        .memory(
                                                                        snapshot.data![index].transaction.image ??
                                                                            Uint8List(0),
                                                                        // width: 80,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            50,
                                                                      )
                                                                    : Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromRGBO(0, 0, 0, 0.1)),
                                                                            child: snapshot.data![index].category.type == 2
                                                                                ? Icon(
                                                                                    Icons.upload_rounded,
                                                                                    color: Colors.red,
                                                                                    size: 40,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.download_rounded,
                                                                                    color: Colors.green,
                                                                                    size: 40,
                                                                                  ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            snapshot
                                                                                .data![index]
                                                                                .transaction
                                                                                .name,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                                color: isDark
                                                                                    ? base
                                                                                    : Colors.black),
                                                                          ),
                                                                          Text(
                                                                              (lang == 0)
                                                                                  ? DateFormat.yMMMMEEEEd(
                                                                                          'id_ID')
                                                                                      .format(
                                                                                      DateTime.parse(snapshot
                                                                                          .data![
                                                                                              index]
                                                                                          .transaction.transaction_date.toString()),
                                                                                    )
                                                                                  : DateFormat
                                                                                          .yMMMMEEEEd()
                                                                                      .format(DateTime.parse(snapshot
                                                                                          .data![
                                                                                              index]
                                                                                          .transaction.transaction_date.toString())),
                                                                              style: TextStyle(
                                                                                  fontSize: 11,
                                                                                  color: isDark
                                                                                      ? base
                                                                                      : home),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        'Rp. ' +
                                                                            (NumberFormat.currency(
                                                                              locale: 'id',
                                                                              decimalDigits: 0,
                                                                            ).format(
                                                                              snapshot.data![index].transaction.amount,
                                                                            )).replaceAll('IDR', ''),
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? base
                                                                                : Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      LinearPercentIndicator(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.52,
                                                                        barRadius: const Radius
                                                                            .circular(
                                                                            16),
                                                                        lineHeight:
                                                                            7.0,
                                                                        percent:
                                                                            calculatePercentage(
                                                                          (snapshot.data![index].transaction.amount)
                                                                              .toDouble(),
                                                                          (type == 1)
                                                                              ? totalIncome.toDouble()
                                                                              : totalExpense.toDouble(),
                                                                        ), // Ganti nilai persentase sesuai kebutuhan
                                                                        progressColor: (type ==
                                                                                1)
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                      ),
                                                                      IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.arrow_forward_ios_sharp,
                                                                            color:
                                                                                primary,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: ((context) => TransactionPage(
                                                                                      transactionWithCategory: snapshot.data![index],
                                                                                    )),
                                                                              ),
                                                                            );
                                                                          })
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        (lang == 0)
                                                            ? 'Tidak ada data'
                                                            : "No data",
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? base
                                                              : home,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      (lang == 0)
                                                          ? 'Tidak ada data'
                                                          : "No data",
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? base
                                                            : home,
                                                      ),
                                                    ),
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
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
