import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:sisaku/colors.dart';
import 'package:sisaku/pages/setting_page.dart';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.dailyAverage,
  });
  // final Rekap? rekap;
  final name;
  final startDate;
  final endDate;
  final totalIncome;
  final totalExpense;
  final dailyAverage;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 35),
      Text(
        widget.name,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: isDark ? base : home),
      ),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Durasi " : "Period",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          widget.startDate + " ~ " + widget.endDate,
          style: TextStyle(color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Total Pemasukan " : "Total Income",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.totalIncome,
              )).replaceAll('IDR', ''),
          style: TextStyle(color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Total Pengeluaran " : "Total Expense",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.totalExpense,
              )).replaceAll('IDR', ''),
          style: TextStyle(color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Rata-Rata Harian " : "Daily Average",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.dailyAverage,
              )).replaceAll('IDR', ''),
          style: TextStyle(color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Sisa " : "Balance",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.totalIncome,
              )).replaceAll('IDR', ''),
          style: TextStyle(color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 27)
    ]);
  }
}
