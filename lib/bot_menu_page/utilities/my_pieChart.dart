import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:pie_chart/pie_chart.dart';

class pieChart extends StatelessWidget{

  int? totalNo;
  String? userName, title;
  int? e,w,i,g;

  pieChart({
    // required this.eNo,
    // required this.wNo,
    // required this.gNo,
    // required this.iNo,
    required this.title,
    required this.totalNo,
    required this.userName,
    required this.e,
    required this.w,
    required this.i,
    required this.g,

});

  // Map<String, double?> dataMap ={
  //
  // };


  final colorList = <Color>[
    Colors.greenAccent,
    Colors.black,
    Colors.red,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(title!,
                  style: TextStyle(color:Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("When there is no usage the pie chart will be grey."
                ),
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: PieChart(
            dataMap: {
              "Eletricity": e!.toDouble(),
              "Gas": g!.toDouble(),
              "Internet": i!.toDouble(),
              "Water": w!.toDouble(),
            },
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: userName,
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,

              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 2,
            ),
          ),

        ),
        SizedBox(height: 10,),
        Divider(),
        SizedBox(height: 10,),

      ],

    );
  }



}