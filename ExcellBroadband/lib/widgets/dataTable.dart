import 'package:ExcellBroadband/helpers/customerInfo.dart';
import 'package:ExcellBroadband/helpers/fadeInY.dart';
import 'package:ExcellBroadband/helpers/utilities.dart';
import 'package:ExcellBroadband/models/lsUtilization.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class UtilDataTable extends StatefulWidget {
  String ipAddr;

  UtilDataTable(this.ipAddr);
  @override
  _UtilDataTableState createState() => _UtilDataTableState(ipAddr);
}

class _UtilDataTableState extends State<UtilDataTable> {
  final LocalStorage storage = new LocalStorage('exbb_app');

  String ipAddr;
  List<dynamic> results = [];
  _UtilDataTableState(this.ipAddr);
  @override
  void initState() {
    _getDataRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return results.length > 0
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FadeInY(
              1.0,
              DataTable(
                  columns: [
                    DataColumn(
                        label: Text('Date '),
                        onSort: (a, b) {
                          print(b.toString());
                        }),
                    DataColumn(label: Text('Total'), numeric: true),
                    DataColumn(label: Text('Download'), numeric: true),
                    DataColumn(label: Text('Upload'), numeric: true),
                  ],
                  rows:
                      List.generate(results.length, (index) => results[index])),
              translate: false,
            ),
          )
        : Container();
  }

  _getDataRow() async {
    List<dynamic> usageReport = await Utilities.getSmartUtilData(ipAddr);
    List<DataRow> dataTableRowsLocal = [];

    var now = new DateTime.now();

    String monthName = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][now.month];

    usageReport.forEach((element) {
      DataRow dataRow = DataRow(cells: [
        DataCell(FadeInY(1.0,
            Text(element["date"].toString().substring(8) + "-" + monthName),
            distance: -5.0)),
        DataCell(FadeInY(
          1.0,
          Text(Utilities.mbToSize(element["total"].toString())),
          distance: -5.0,
        )),
        DataCell(FadeInY(1.0, Text(Utilities.mbToSize(element["download"])),
            distance: -5.0)),
        DataCell(FadeInY(
            1.0, Text(Utilities.mbToSize(element["upload"].toString())),
            distance: -5.0)),
      ]);
      dataTableRowsLocal.add(dataRow);
    });

    setState(() {
      results = dataTableRowsLocal;
    });
  }
}
