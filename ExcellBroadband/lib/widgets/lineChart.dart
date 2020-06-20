import 'package:ExcellBroadband/helpers/constants.dart';
import 'package:ExcellBroadband/helpers/fadeInY.dart';
import 'package:ExcellBroadband/helpers/utilities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UtilLineChart extends StatefulWidget {
  final String ipAddr;

  UtilLineChart(this.ipAddr);

  @override
  _UtilLineChartState createState() => _UtilLineChartState(ipAddr);
}

class _UtilLineChartState extends State<UtilLineChart> {
  String ipAddr;
  List<dynamic> results;
  double maxY, minY, minX, maxX;
  // double ;

  _UtilLineChartState(this.ipAddr);

  void initState() {
    _getDataRow();
    super.initState();
  }

  List<Color> gradientColors = Constants.colors['gradient_colors3'];

  // [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

  bool showAvg = false;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        color: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: myBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(
                  // right: 18.0, left: 12.0, top: 0, bottom: 12),
                  right: 0.0,
                  left: 0.0,
                  top: 0,
                  bottom: 0),
              child: results != null && results.length > 0
                  ? FadeInY(
                      0.1,
                      LineChart(
                        mainData(results),
                      ),
                      translate: false,
                    )
                  : Container(
                      child: Center(child: Text("No Data")),
                    ),
            ),
          ),
        ),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: FlatButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       'avg',
        //       style: TextStyle(
        //           fontSize: 12,
        //           color:
        //               showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  LineChartData mainData(_results) {
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
    List<int> stepValues = [
      1,2,
    ];
print(maxX.toString()  +" maxX");
    if (maxX == 3.0)
      stepValues = [2];
    else if (maxX == 4.0)
      stepValues = [2, 3];
    else if (maxX == 5.0)
      stepValues = [2, 4];
    else if (maxX == 6.0)
      stepValues = [2, 4];
    else if (maxX == 7.0)
      stepValues = [2, 5];
    else if (maxX == 8.0)
      stepValues = [2, 5, 7];
    else if (maxX == 9.0)
      stepValues = [2, 6, 8];
    else if (maxX == 10.0)
      stepValues = [2, 5, 7, 9];
    else if (maxX == 11.0)
      stepValues = [2, 5, 7, 10];
    else if (maxX == 12.0)
      stepValues = [2, 4, 7, 9, 11];
    else if (maxX == 13.0)
      stepValues = [2, 5, 8, 10, 12];
    else if (maxX == 14.0)
      stepValues = [2, 5, 8, 11, 13];
    else if (maxX == 15.0) stepValues = [2, 5, 8, 12, 14];
    else if (maxX == 16.0) stepValues = [2, 5, 8, 11, 15];
    else if (maxX == 17.0) stepValues = [2, 6, 9, 12, 16];
    else if (maxX == 18.0) stepValues = [2,];
    else if (maxX == 19.0) stepValues = [2,];
    else if (maxX == 20.0) stepValues = [2,];
    else if (maxX == 21.0) stepValues = [2,];
    else if (maxX == 22.0) stepValues = [2,];
    else if (maxX == 23.0) stepValues = [2,];
    else if (maxX == 24.0) stepValues = [2,];
    else if (maxX == 25.0) stepValues = [2,];
    else if (maxX == 26.0) stepValues = [2,];
    else if (maxX == 27.0) stepValues = [2,];
    else if (maxX == 28.0) stepValues = [2,];
    else if (maxX == 29.0) stepValues = [2,];
    else if (maxX == 30.0) stepValues = [2,];
    else if (maxX == 31.0) stepValues = [2,];

/*

Srinivas T

7881
7993048888

Hari

96733
9000622123




*/



    return LineChartData(
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[400],
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {


            if (stepValues.indexOf(value.toInt()) != -1)
              return value.toInt().toString() + "-" + monthName;

            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      minX: 1,
      maxX: double.parse(_results.length.toString()),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(_results.length, (index) => _results[index]),
          isCurved: true,
          colors: [
            const Color(0xff23b6e6),
            const Color(0xff02d39a),
          ],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            // spotsLine: BarAreaSpotsLine(show:true),
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 21,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.5),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  _getDataRow() async {
    List<dynamic> usageReport = await Utilities.getSmartUtilData(ipAddr);
    List<FlSpot> flSpots = [];
    double _maxY = 0;
    double _minY = 0;
    double _minX = 1;
    double _maxX = 0;

    usageReport.forEach((element) {
      double y = double.parse(element["total"]);
      double x = double.parse(element["date"].toString().substring(8));

      _maxY = _maxY > y ? _maxY : y;
      _minY = _minY < y ? _minY : y;

      _maxX = _maxX > x ? _maxX : x;
      _minX = _minX < x ? _minX : x;

      // print(element["date"].toString() + " " + element["total"].toString());

      flSpots.add(FlSpot(x, y));
    });

    print("_maxY" + " " + _maxY.toString());
    print("_minY" + " " + _minY.toString());

    setState(() {
      results = flSpots;
      maxY = _maxY + 10000;
      minY = _minY - 30000;

      maxX = _maxX;
      minX = _minX;

      // print(results.toString());
    });
  }
}

/* Spots
// [
//   FlSpot(1, 22),
//   FlSpot(2, 9),
//   FlSpot(3, 23),
//   FlSpot(4, 3),
//   FlSpot(5, 28),
//   FlSpot(6, 31),
//   FlSpot(7, 17),
//   FlSpot(8, 22),
//   FlSpot(9, 5),

//   // FlSpot(10, 41),
//   // FlSpot(11, 36),
//   // FlSpot(12, 39),
//   // FlSpot(13, 21),
//   // FlSpot(14, 18),
//   // FlSpot(15, 23),
//   // FlSpot(16, 26),
//   // FlSpot(17, 5),
//   // FlSpot(18, 23),
//   // FlSpot(19, 8),
//   // FlSpot(20, 37),
//   // FlSpot(21, 14),
//   // FlSpot(22, 28),
//   // FlSpot(23, 41),
//   // FlSpot(24, 20),
//   // FlSpot(25, 41),
//   // FlSpot(26, 6),
//   // FlSpot(27, 43),
//   // FlSpot(28, 14),
//   // FlSpot(29, 28),
//   // FlSpot(30, 19),
//   // FlSpot(31, 9),
// ],
*/
