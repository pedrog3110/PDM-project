import 'package:flutter/material.dart';
import 'package:health/health.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Health health = Health();
  double _sleepHours = 0.0;
  bool _isFetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isFetching ? null : _fetchSleepData,
                child: Text('Fetch Sleep Data'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              _isFetching
                  ? CircularProgressIndicator()
                  : Text(
                "Total sleep hours: ${_sleepHours.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchSleepData() async {
    setState(() {
      _isFetching = true;
    });

    DateTime startDate = DateTime.now().subtract(Duration(days: 1));
    DateTime endDate = DateTime.now();


    List<HealthDataType> types = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_IN_BED,
    ];


    bool requested = await health.requestAuthorization(types);

    if (requested) {

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: types,
        startTime: startDate,
        endTime: endDate,
      );

      double sleepHours = 0.0;

      for (HealthDataPoint data in healthData) {

        if (data.type == HealthDataType.SLEEP_ASLEEP || data.type == HealthDataType.SLEEP_IN_BED) {

          double valueInMillis;
          if (data.value is int) {
            valueInMillis = (data.value as int).toDouble();
          } else if (data.value is double) {
            valueInMillis = data.value as double;
          } else {

            continue;
          }

          sleepHours += valueInMillis / 3600000; //
        }
      }

      setState(() {
        _sleepHours = sleepHours;
      });
    }

    setState(() {
      _isFetching = false;
    });
  }
}