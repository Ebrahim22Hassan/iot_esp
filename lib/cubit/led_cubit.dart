import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iot_esp/screens/control_screen.dart';
import 'package:iot_esp/screens/graph_screen.dart';
import 'package:iot_esp/screens/reading_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rainbow_color/rainbow_color.dart';
import '../main.dart';
import '../notification_class.dart';

part 'led_state.dart';

class LedCubit extends Cubit<LedState> {
  LedCubit(this.sensorReading) : super(LedInitial());

  bool ledON = true;
  final dataBase = FirebaseDatabase.instance.ref();

  int index = 1;
  List<Widget> activeScreen = const [
    ReadingScreen(),
    ControlScreen(),
    GraphScreen()
  ];

  void changeCurrentScreen(int screen) {
    index = screen;
    emit(NavBarChanged());
  }

  /// MOTORS CONTROL
  bool motor1Active = false;

  void updateColor() {
    motor1Active = !motor1Active;
    emit(ContainerColorChanged());
  }

  bool motor2Active = false;

  void updateColor2(motorNum) {
    motorNum = !motorNum;
    emit(ContainerColorChanged());
  }

  List<IconData> activeFloatingIcon = [
    Icons.keyboard_voice_outlined,
    Icons.camera_alt_outlined,
    Icons.remove_red_eye_outlined,
  ];

  void floatingActionButtonPressed(BuildContext context) {
    switch (index) {
      case 1:
        //getImage();
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReadingScreen(),
            ));
    }
  }

  var activeColor = Rainbow(spectrum: [
    const Color(0xFFC421A0),
    const Color(0xFF6D04E2),
    const Color(0xFF1086D4),
    const Color(0xFF05E9ED), //
    const Color(0xFF33C0BA),
    const Color(0xFFE4262F),
    const Color(0xFFBA0000) //
  ], rangeStart: 0.0, rangeEnd: 1.0);

  List<Color> activeBSColor = [
    const Color(0xFF1086D4).withOpacity(0.8),
    const Color(0xFF33C0BA).withOpacity(0.8),
    const Color(0xFFC421A0).withOpacity(0.8),
  ];

  List<Color> activeBGColor = const [
    Color(0xFF1086D4),
    Color(0xFF33C0BA),
    Color(0xFFC421A0),
  ];

  var sensorReading;
  var minutes;
  var temperature;

  void getDataB() {
    emit(DataGetting());
    dataBase.onValue.listen((DatabaseEvent event) async {
      final pHSnap = await dataBase.child('esp/pH').get();
      final tempSnap = await dataBase.child('esp/temp').get();
      final minutesSnap = await dataBase.child('esp/minutes').get();
      sensorReading = pHSnap.value;
      temperature = tempSnap.value;
      minutes = minutesSnap.value;
      //print(data);
      //print(snap.value);
      emit(DataGot());
      //getJson();
      if (sensorReading > 7.8 || sensorReading < 7.0) {
        getSound();
      }
    });
    dataBase.child('esp').onChildChanged.listen((event) {
      DataSnapshot snap = event.snapshot;
      DataSnapshot snap1 = event.snapshot;
      if (snap.key == 'pH' && snap1.key == 'temp') {
        sensorReading = snap.value;
        temperature = snap1.value;
        emit(DataGot());
      }
    });
  }

  void ledChange() {
    emit(LedPressed());
    if (ledON == true) {
      ledON = false;
    } else {
      ledON = true;
    }
    final child = dataBase.child('esp/');
    int boolString = ledON ? 1 : 0;
    child.update({'LED': boolString});
    emit(LedChanged());
  }

  /// MOTORS WITH FIREBASE
  void motor1Change() {
    emit(MotorPressed());
    motor1Active = !motor1Active;
    final child = dataBase.child('esp/');
    int boolString = motor1Active ? 1 : 0;
    child.update({'motor': boolString});
    emit(MotorChanged());
  }

  void motor2Change() {
    emit(MotorPressed());
    motor2Active = !motor2Active;
    final child = dataBase.child('esp/');
    int boolString = motor2Active ? 1 : 0;
    child.update({'motor2': boolString});
    emit(MotorChanged());
  }

  List<dynamic>? ldrValues;
  String? json;

  int itemCount = 60;
  List<double> data = [];
  List<String> time = [];

  Future getJson() async {
    emit(JsonGet());
    var url = Uri.parse(
        // "https://script.google.com/macros/s/AKfycbxtotcYO5aDFqCwzqsAcbdX050bSTu1jUqVTSInq979UFwq9lZkgRhaUBjJYhmmGZjO/exec");
        "https://script.google.com/macros/s/AKfycbzYTxQsEsVY34YD4VPiGn8ZHZNMEhJMf_aJzE69gj92qlb_B2_qIzKoSeqLY9yLJuk/exec");
    json = await http.read(url).then((value) {
      ldrValues = jsonDecode(value);
      //print(ldrValues);

      itemCount = ldrValues!.length < 60 ? ldrValues!.length : 60;
      var dataUsed = ldrValues!.sublist(0, itemCount);
      data = [];
      time = [];
      for (var element in dataUsed) {
        data.add((element['value'].toDouble()) / 10);
        time.add(element['date'].split('T')[1].substring(0, 5));
      }
      emit(JsonGot());
      return value;
    });
  }

  ///******Sound********/
  void getSound() {
    dataBase.onValue.listen((event) async {
      final sound = await dataBase.child('notification/status').get();
      var soundStatus = sound.value.toString();
      if (soundStatus == "1") {
        Notify.showBigTextNotification(
            title: "Smart Swimming Pool: ",
            body: sensorReading > 7.8
                ? "High pH Level: $sensorReading, Temperature: $temperature°"
                : "Low pH Level: $sensorReading, Temperature: $temperature°",
            fln: flutterLocalNotificationsPlugin);
        final child = dataBase.child('notification/');
        int spot = 0;
        child.update({'status': spot});
      }
      //emit(SoundStatusSuccessState());
    });
  }
}
