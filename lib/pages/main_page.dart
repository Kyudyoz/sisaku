// import 'package:drift/drift.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sisaku/main.dart';
// import 'package:sisaku/pages/category_page.dart';
// import 'package:sisaku/pages/gallery_pages.dart';
// import 'package:sisaku/pages/home_page.dart';
// import 'package:sisaku/pages/rekap_page.dart';
// import 'package:sisaku/pages/setting_page.dart';
// import 'package:sisaku/pages/transaction_page.dart';
// import 'package:get/get.dart';

// class MainPage extends StatefulWidget {
//   final DateTime date;
//   const MainPage({super.key, required this.date});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   void initState() {
//     loadData();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     dataDate = widget.date;
//     return Scaffold(
//       bottomNavigationBar: Obx(
//         () => NavigationBar(
//           backgroundColor: base,
//           height: 60,
//           elevation: 0,
//           animationDuration: Duration(milliseconds: 200),
//           indicatorColor: Colors.transparent,
//           selectedIndex: (controller.selectedIndex.value == 4)
//               ? 0
//               : controller.selectedIndex.value,
//           onDestinationSelected: (index) =>
//               controller.selectedIndex.value = index,
//           destinations: [
//             NavigationDestination(
//                 icon: Icon(Icons.home),
//                 label: '',
//                 selectedIcon: Icon(
//                   Icons.home,
//                   color: primary,
//                 )),
//             NavigationDestination(
//                 icon: Icon(Icons.list),
//                 label: '',
//                 selectedIcon: Icon(
//                   Icons.list,
//                   color: primary,
//                 )),
//             NavigationDestination(
//                 icon: Icon(Icons.bar_chart),
//                 label: '',
//                 selectedIcon: Icon(
//                   Icons.bar_chart,
//                   color: primary,
//                 )),
//             NavigationDestination(
//                 icon: Icon(Icons.settings),
//                 label: '',
//                 selectedIcon: Icon(
//                   Icons.settings,
//                   color: primary,
//                 )),
//           ],
//         ),
//       ),
//       body: Obx(
//         () => controller.screens[controller.selectedIndex.value],
//       ),
//       backgroundColor: primary,
//     );
//   }
// }

// final controller = Get.put(MainController());

// late DateTime dataDate;

// class MainController extends GetxController {
//   final Rx<int> selectedIndex = 0.obs;
//   final screens = [
//     HomePage(selectedDate: dataDate),
//     CategoryPage(),
//     RekapPage(),
//     SettingPage(),
//     TransactionPage(transactionWithCategory: null),
//   ];
// }
