import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Prueba extends StatefulWidget{
  const Prueba({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<Prueba> createState()  => _PruebaState();
}

class _PruebaState extends State<Prueba> {

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(2010, 35),
      ChartData(2011, 28),
      ChartData(2012, 34),
      ChartData(2013, 32),
      ChartData(2014, 40)
    ];
    print(chartData);
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    series: <ChartSeries>[
                      // Renders line chart
                      LineSeries<ChartData, int>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y
                      )
                    ]
                )
            )
        )
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
