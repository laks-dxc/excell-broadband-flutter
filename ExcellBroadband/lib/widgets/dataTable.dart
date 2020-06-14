import 'package:ExcellBroadband/helpers/customerInfo.dart';
import 'package:ExcellBroadband/helpers/utilities.dart';
import 'package:flutter/material.dart';

class UtilDataTable extends StatefulWidget {
  String ipAddr;
  UtilDataTable(this.ipAddr);
  @override
  _UtilDataTableState createState() => _UtilDataTableState(ipAddr);
}

class _UtilDataTableState extends State<UtilDataTable> {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: [
        DataColumn(label: Text('Date ')),
        DataColumn(label: Text('Upload'), numeric: true),
        DataColumn(label: Text('Download'), numeric: true),
        DataColumn(label: Text('Total'), numeric: true),
      ], rows: List.generate(results.length, (index) => results[index])),
    );
  }

  _getDataRow() {
    List<DataRow> dataTableRowsLocal = [];

    CustomerInfo.usageReport(ipAddr).then((usageReportResponse) {
      if (Utilities.getStatus(usageReportResponse) == 200) {
        List<dynamic> usageReport =
            usageReportResponse["resonse"]["result"]["usagereport"];

        // print(usageReport.toString());

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
            DataCell(Text(
                element["date"].toString().substring(8) + "-" + monthName)),
            DataCell(Text(Utilities.mbToSize(element["upload"].toString()))),
            DataCell(Text(Utilities.mbToSize(element["download"]))),
            DataCell(Text(Utilities.mbToSize(element["total"].toString()))),
          ]);
          dataTableRowsLocal.add(dataRow);
          // print(dataTableRowsLocal);
        });

        setState(() {
          results = dataTableRowsLocal;
        });
      } else {
        print("Error " + usageReportResponse.toString());
      }
    });
    // return dataTableRowsLocal;
  }
}
