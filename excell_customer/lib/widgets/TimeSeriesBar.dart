import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData() {
    return new StackedBarChart(
      _createSampleData(),

      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
       barGroupingType: charts.BarGroupingType.grouped,
       behaviors: [new charts.SeriesLegend()],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<MonthlyUtilization, String>> _createSampleData() {
    final desktopSalesData = [
      new MonthlyUtilization('2014', 5),
      new MonthlyUtilization('2015', 25),
      new MonthlyUtilization('2016', 100),
      // new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new MonthlyUtilization('2014', 25),
      new MonthlyUtilization('2015', 50),
      new MonthlyUtilization('2016', 10),
      new MonthlyUtilization('2017', 20),
    ];



    return [
      new charts.Series<MonthlyUtilization, String>(
        id: 'Desktop',
        domainFn: (MonthlyUtilization sales, _) => sales.day,
        measureFn: (MonthlyUtilization sales, _) => sales.dataInMB,
        data: desktopSalesData,
      ),
      new charts.Series<MonthlyUtilization, String>(
        id: 'Tablet',
        domainFn: (MonthlyUtilization sales, _) => sales.day,
        measureFn: (MonthlyUtilization sales, _) => sales.dataInMB,
        data: tableSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class MonthlyUtilization {
  final String day;
  final double dataInMB;

  MonthlyUtilization(this.day, this.dataInMB);
}