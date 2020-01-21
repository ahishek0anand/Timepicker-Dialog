import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:timer_builder/timer_builder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

String formatDuration(Duration d) {
  String f(int n) {
    return n.toString().padLeft(2, '0');
  }
  // We want to round up the remaining time to the nearest second
  d += Duration(microseconds: 999999);
  return "${f(d.inMinutes)}:${f(d.inSeconds%60)}";
}







class Stoptimer extends StatefulWidget {
  const Stoptimer({Key key}) : super(key: key);

  @override
  _StoptimerState createState() => _StoptimerState();
}

class _StoptimerState extends State<Stoptimer> {
  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          Text("$_start")
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime alert;
  int currentime;
  int selectedRadioTile;
  int selectedRadio;
  int min =DateTime.now().minute;
  int  hour = DateTime.now().hour;
  DateTime _dateTime = DateTime.now();
  String formattedDate;
  DateTime settime ;
  
  var stopwatch = new Stopwatch()..start();
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    currentime = 0;
    alert = DateTime.now().add(Duration(seconds: 60));
    settime=DateTime.now().subtract(Duration(hours: hour,minutes: min));
    
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    
     

 Scaffold(
    body: TimerBuilder.scheduled([alert],
            builder: (context) {
              // This function will be called once the alert time is reached
              var now = DateTime.now();
              var reached = now.compareTo(alert) >= 0;
              final textStyle = Theme.of(context).textTheme.title;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){

   showTimerlist(context);

                      },
                                        child: Icon(
                        reached ? Icons.alarm_on: Icons.alarm,
                        color: reached ? Colors.red: Colors.green,
                        size: 48,
                      ),
                    ),
                    !reached ?
                      TimerBuilder.periodic(
                          Duration(seconds: 1),
                          alignment: Duration.zero,
                          builder: (context) {
                            // This function will be called every second until the alert time
                            var now = DateTime.now();
                            var remaining = alert.difference(now);
                            return Text(formatDuration(remaining), style: textStyle,);
                          }
                      )
                      :
                      Text("Alert", style: textStyle),
                    
                  ],
                ),
              );
            } 
      ),
 );
  }

  showTimerlist(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 700,
                  width: 500,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.teal),
                        child: Center(
                            child: Text(
                          "Set Timer",
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _radiolist()
                    ],
                  )));
        });
  }

  Widget _radiolist() {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTile,
              title: Text("No Timer"),
              
              onChanged: (val) {
                 
               
                 setState(() {
                     alert=DateTime.now();
                 });
                print("Radio Tile pressed $val");
                    Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: true,
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadioTile,
              title: Text("Custom Duration"),
              onChanged: (val) {
                print("Radio Tile pressed $val");

                Navigator.of(context).pop();
                customtimer(context);
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 3,
              groupValue: selectedRadioTile,
              title: Text("5 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
               
                setState(() {
                  currentime = 5;
                  alert = DateTime.now().add(Duration(minutes: 5));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 4,
              groupValue: selectedRadioTile,
              title: Text("10 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
               
                setState(() {
                  currentime = 10;
                   alert = DateTime.now().add(Duration(minutes: 10));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 5,
              groupValue: selectedRadioTile,
              title: Text("15 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
         
                setState(() {
                  currentime = 15;
                   alert = DateTime.now().add(Duration(minutes: 15));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 6,
              groupValue: selectedRadioTile,
              title: Text("20 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
               
                setState(() {
                  currentime = 20;
                   alert = DateTime.now().add(Duration(minutes: 20));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 7,
              groupValue: selectedRadioTile,
              title: Text("30 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
             
                setState(() {
                  currentime = 30;
                  alert = DateTime.now().add(Duration(minutes: 30));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 8,
              groupValue: selectedRadioTile,
              title: Text("40 Minutes"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
           
                setState(() {
                  currentime = 40;
                    alert = DateTime.now().add(Duration(minutes: 40));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 9,
              groupValue: selectedRadioTile,
              title: Text("1 Hour"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
       
                setState(() {
                  currentime = 60;
                    alert = DateTime.now().add(Duration(minutes: 60));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 10,
              groupValue: selectedRadioTile,
              title: Text("2 Hour"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
              
                setState(() {
                  currentime = 120;
                    alert = DateTime.now().add(Duration(hours: 2));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile(
              value: 11,
              groupValue: selectedRadioTile,
              title: Text("4 Hour"),
              onChanged: (val) {
                print("Radio Tile pressed $val");
             
                setState(() {
                  currentime = 240;
                     alert = DateTime.now().add(Duration(hours: 4));
                });
                Navigator.of(context).pop();
              },
              activeColor: Colors.red,
              selected: false,
            )
          ],
        ),
      ),
    );
  }

  customtimer(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 400,
                  width: 500,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.teal),
                        child: Center(
                            child: Text(
                          "Custom Timer Duration",
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                      _timepiker()
                    ],
                  )));
        });
  }

  Widget timeshow(DateTime startime) {
    return TimePickerSpinner(
      isForce2Digits: true,
      is24HourMode: true,
      spacing: 50,
      normalTextStyle: TextStyle(fontSize: 16),
      highlightedTextStyle:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      time: startime,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
          formattedDate = DateFormat('kk:mm').format(_dateTime);
        });
      },
    );
  }

  Widget _timepiker() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Text(
                  "Hour",
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  "Minutes",
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              timeshow(settime),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 70,
                    ),
                    Container(
                      color: Colors.black,
                      width: 60,
                      height: 3,
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      color: Colors.black,
                      width: 60,
                      height: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 70,
                    ),
                    Container(
                      color: Colors.black,
                      width: 60,
                      height: 3,
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      color: Colors.black,
                      width: 60,
                      height: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          RaisedButton(
            
            onPressed: () {
              setState(() {
               int hr= _dateTime.hour;
               int mi=_dateTime.minute;
                alert = DateTime.now().add(Duration(minutes: mi,hours: hr));
                
              });
              Navigator.of(context).pop();
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 35, right: 35, top: 8, bottom: 8),
              child: Text(
                "Set Timer",
                style: TextStyle(fontSize: 24),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${_dateTime}"),
          )
        ],
      ),
    );
  }
}

//custom timer
