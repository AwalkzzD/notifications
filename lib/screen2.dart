/*
import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            uploadFile();
          },
          child: const Icon(Icons.add)),
    );
  }

  // method to upload xls file
  Future<void> uploadFile() async {
    ByteData data = await rootBundle.load('assets/xls_file.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      log(table); //sheet Name
      log("${excel.tables[table]?.maxColumns}");
      log("${excel.tables[table]?.maxRows}");
      for (var row in excel.tables[table]!.rows) {
        for (var value in row) {
          log(value!.value.toString());
        }
      }
    }
  }
}
*/

import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<DataColumn> _columns = [];
  List<DataRow> _rows = [];
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Data'),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadFile();
        },
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: _columns, rows: _rows),
            ),
    );
  }

  // Method to upload and read xls file
  Future<void> uploadFile() async {
    ByteData data = await rootBundle.load('assets/xls_file.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    // Clear previous data
    _columns.clear();
    _rows.clear();

    // Assuming you are working with the first sheet
    String sheetName = excel.tables.keys.first;
    var table = excel.tables[sheetName];

    if (table != null) {
      // Create columns from the first row (header)
      _columns = table.rows.first
          .map((value) => DataColumn(
                label: Text(value?.value.toString() ?? ''),
              ))
          .toList();

      // Create rows for the remaining data
      _rows = table.rows.skip(1).map((row) {
        return DataRow(
          cells: row.map((value) {
            return DataCell(Text(value?.value.toString() ?? ''));
          }).toList(),
        );
      }).toList();

      setState(() {
        _loading = false;
      });
    } else {
      log('No data found in the Excel sheet.');
    }
  }
}
