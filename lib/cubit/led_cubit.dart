import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_esp/screens/control_screen.dart';
import 'package:iot_esp/screens/graph_screen.dart';
import 'package:iot_esp/screens/reading_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rainbow_color/rainbow_color.dart';
part 'led_state.dart';

class LedCubit extends Cubit<LedState> {
  LedCubit(this.sensorReading) : super(LedInitial());

  bool ledON = true;
  var sensorReading;
  var minutes;
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

  bool motorActive = false;
  void updateColor() {
    motorActive = !motorActive;
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

  void getDataB() {
    emit(DataGetting());
    // dataBase.child('ESP').once().then((snap) {
    //   sensorReading = snap.value['LDR'] is int
    //       ? snap.value['LDR']
    //       : int.parse(snap.value['LDR']);
    //   minutes = snap.value['minutes'] is int
    //       ? snap.value['minutes']
    //       : int.parse(snap.value['minutes']);
    //   rColor = snap.value['rColor'];
    //   gColor = snap.value['gColor'];
    //   bColor = snap.value['bColor'];
    //   ledON = snap.value['LED'] == 1;
    //   rgbColor = Color.fromRGBO(rColor, gColor, bColor, 1);
    //   emit(DataGot());
    // }).then((value) {
    //   getJson();
    // });
    dataBase.onValue.listen((DatabaseEvent event) async {
      //final data = event.snapshot.value;
      final ldrSnap = await dataBase.child('esp/LDR').get();
      final minutesSnap = await dataBase.child('esp/minutes').get();

      sensorReading = ldrSnap.value;
      minutes = minutesSnap.value;

      //print(data);
      //print(snap.value);
      emit(DataGot());
      getJson();
      //getJson() as Map;
    });

    dataBase.child('esp').onChildChanged.listen((event) {
      DataSnapshot snap = event.snapshot;
      if (snap.key == 'LDR') {
        sensorReading = snap.value;
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
    //print(ledON);
    emit(LedChanged());
  }

  void motorChange() {
    emit(MotorPressed());
    motorActive = !motorActive;
    final child = dataBase.child('esp/');
    int boolString = motorActive ? 1 : 0;
    child.update({'motor': boolString});
    emit(MotorChanged());
  }

  List<dynamic>? ldrValues;
  String? json;

  int itemCount = 60;
  List<double> data = [];
  List<String> time = [];

  Future getJson() async {
    emit(JsonGet());
    // var url = Uri.parse(
    //   "https://script.googleusercontent.com/macros/echo?user_content_key=AzV2E5t0_nErlSxJM-LT2DpwvOuxLOmetGvl8eAQMH6xucI36CqN7N0ZG12mY_bZ48y8Y1NVMrZNRVY0MXRDmKdd1T7ToMjym5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnAG_t5JAlCBYh-4pzFuo0hYylFyXMGeacPvHeSyhPRMZEZkQ5vpwvq4snJvFGrWJT3jeEKenHH9lcJhMnYxoaSFlBLShXJG4bw&lib=M_MTsbg1Oc4iS5ELx-TpVngHKiz3AQw03");
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxtotcYO5aDFqCwzqsAcbdX050bSTu1jUqVTSInq979UFwq9lZkgRhaUBjJYhmmGZjO/exec");
    json = await http.read(url).then((value) {
      ldrValues = jsonDecode(value);
      //print(ldrValues);

      itemCount = ldrValues!.length < 60 ? ldrValues!.length : 60;
      var dataUsed = ldrValues!.sublist(0, itemCount);
      data = [];
      time = [];
      for (var element in dataUsed) {
        data.add((element['value'].toDouble()) / 100);
        time.add(element['date'].split('T')[1].substring(0, 5));
      }
      emit(JsonGot());
      return value;
    });
  }
}
