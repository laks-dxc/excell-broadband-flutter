// import 'package:ExcellBroadband/helpers/customerInfo.dart';
// import 'package:ExcellBroadband/helpers/FadeIn.dart';
// import 'package:ExcellBroadband/helpers/Utils.dart';
// import 'package:ExcellBroadband/models/lsUtilization.dart';
import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';

class UtilDataTable extends StatefulWidget {
  final String ipAddr;

  UtilDataTable(this.ipAddr);
  @override
  _UtilDataTableState createState() => _UtilDataTableState(ipAddr);
}

class _UtilDataTableState extends State<UtilDataTable> {
  // final LocalStorage storage = new LocalStorage('exbb_app');

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
            child: FadeIn(
              DataTable(columns: [
                DataColumn(
                    label: Text('Date '),
                    onSort: (a, b) {
                      // print(b.toString());
                    }),
                DataColumn(label: Text('Total'), numeric: true),
                DataColumn(label: Text('Download'), numeric: true),
                DataColumn(label: Text('Upload'), numeric: true),
              ], rows: List.generate(results.length, (index) => results[index])),
              1.0,
              translate: false,
            ),
          )
        : Container();
  }

  _getDataRow() async {
    List<dynamic> usageReport = await Customer.getSmartUtilData(ipAddr);

    List<DataRow> dataTableRowsLocal = [];

    var now = new DateTime.now();

    String monthName = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month];

    usageReport.forEach((element) {
      DataRow dataRow = DataRow(cells: [
        DataCell(FadeIn(Text(element["date"].toString().substring(8) + "-" + monthName), 1.0, distance: -5.0)),
        DataCell(FadeIn(
          Text(Utils.mbToSize(element["total"].toString())),
          1.0,
          distance: -5.0,
        )),
        DataCell(FadeIn(Text(Utils.mbToSize(element["download"])), 1.0, distance: -5.0)),
        DataCell(FadeIn(Text(Utils.mbToSize(element["upload"].toString())), 1.0, distance: -5.0)),
      ]);
      dataTableRowsLocal.add(dataRow);
    });

    setState(() {
      results = dataTableRowsLocal;
    });
  }
}
