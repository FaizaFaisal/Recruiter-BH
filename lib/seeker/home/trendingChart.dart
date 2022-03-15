import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class TrendingChart extends StatefulWidget {
  const TrendingChart({Key? key}) : super(key: key);

  @override
  _TrendingChartState createState() => _TrendingChartState();
}

class _TrendingChartState extends State<TrendingChart> {
  //  data from the firestore
  List<OriginalData> originalData = <OriginalData>[
    OriginalData('Software', 35),
    OriginalData('Software', 28),
    OriginalData('Software', 34),
    OriginalData('Software', 24),
    OriginalData('Design', 32),
    OriginalData('Design', 40),
    OriginalData('Business', 29),
  ];

  // Store the available status types in a collection.
  List<String> statusTypes = ['Software', 'Design', 'Business'];

  // count variables to store the count of the each state available
  int software_count = 0, design_count = 0, business_count = 0;

  // initialize a chart data collection with each status field with 0 count value
  List<ChartData> chartData = [
    ChartData('Software', 0),
    ChartData('Design', 0),
    ChartData('Business', 0),
  ];

  @override
  void initState() {
    // parse into original data to check teh count of the status field available and
    // store the count in thier respective count variables.

    print(software_count);
    FirebaseFirestore.instance
        .collection("jobs")
        .where("category", isEqualTo: 'Software')
        .where("job_status", isEqualTo: 'Active')
        .get()
        .then((snapshot) => {
              print(snapshot.docs.length),
              setState(() {
                software_count = snapshot.docs.length;
                chartData[0].statusCount = software_count;
              }),
            });

    FirebaseFirestore.instance
        .collection("jobs")
        .where("category", isEqualTo: 'Design')
        .where("job_status", isEqualTo: 'Active')
        .get()
        .then((snapshot) => {
              print(snapshot.docs.length),
              setState(() {
                design_count = snapshot.docs.length;
                chartData[1].statusCount = design_count;
              }),
            });

    FirebaseFirestore.instance
        .collection("jobs")
        .where("category", isEqualTo: 'Business')
        .where("job_status", isEqualTo: 'Active')
        .get()
        .then((snapshot) => {
              print(snapshot.docs.length),
              setState(() {
                business_count = snapshot.docs.length;
                chartData[2].statusCount = business_count;
              }),
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: menuAppBar(context, 'Trending Jobs Categories'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfCircularChart(
                title: ChartTitle(text: "Jobs Categories"),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries<ChartData, String>>[
                  PieSeries<ChartData, String>(
                      radius: '76%',
                      dataSource: chartData,
                      xValueMapper: (ChartData sales, _) => sales.status,
                      yValueMapper: (ChartData sales, _) => sales.statusCount,
                      dataLabelMapper: (ChartData data, _) {
                        return data.status +
                            ' (${data.statusCount.toString()})';
                      },
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelIntersectAction: LabelIntersectAction.none,
                          labelPosition: ChartDataLabelPosition.outside)),
                ],
              ),
            ],
          ),
        ));
  }
}

class OriginalData {
  OriginalData(this.status, this.otherData);

  final String status;
  final double otherData;
}

class ChartData {
  ChartData(this.status, this.statusCount);

  final String status;
  int statusCount;
}
