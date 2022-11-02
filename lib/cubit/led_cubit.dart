import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot_esp/screens/control_screen.dart';
import 'package:iot_esp/screens/graph_screen.dart';
import 'package:iot_esp/screens/reading_screen.dart';
import 'package:iot_esp/screens/rgb_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;
part 'led_state.dart';

class LedCubit extends Cubit<LedState> {
  LedCubit() : super(LedInitial());

  bool ledON = true;
  var sensorReading;
  var minutes;
  final dataBase = FirebaseDatabase.instance.ref();

  int index = 0;
  List<Widget> activeScreen = [ControlScreen(), RGBScreen(), GraphScreen()];

  void changeCurrentScreen(int screen) {
    index = screen;
    emit(NavBarChanged());
  }

  List<IconData> activeFloatingIcon = [
    Icons.keyboard_voice_outlined,
    Icons.camera_alt_outlined,
    Icons.remove_red_eye_outlined,
  ];

  void floatingActionButtonPressed(BuildContext context) {
    switch (index) {
      case 1:
        getImage();
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingScreen(),
            ));
    }
  }

  var rColor, gColor, bColor;
  Color rgbColor = Colors.red;

  void rgbColorChanged(r, g, b) {
    emit(RGBColorChanging());
    rColor = r;
    gColor = g;
    bColor = b;
    rgbColor = Color.fromRGBO(r, g, b, 1);
    final child = dataBase.child('esp/');
    child.update({
      'rColor': r,
      'gColor': g,
      'bColor': b,
    }).then((value) {
      emit(RGBColorChanged());
    });
  }

  void getDataB() {
    // emit(DataGetting());
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
      final data = event.snapshot.value;
      final ldrSnap = await dataBase.child('esp/LDR').get();
      final minutesSnap = await dataBase.child('esp/minutes').get();
      final rSnap = await dataBase.child('esp/rColor').get();
      final gSnap = await dataBase.child('esp/gColor').get();
      final bSnap = await dataBase.child('esp/bColor').get();
      sensorReading = ldrSnap.value;
      minutes = minutesSnap.value;
      rColor = rSnap.value;
      gColor = gSnap.value;
      bColor = bSnap.value;
      rgbColor = Color.fromRGBO(rColor, gColor, bColor, 1);
      print(data);
      //print(snap.value);
      emit(DataGot());
      getJson() as Map;
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
    print(ledON);
    emit(LedChanged());
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    emit(PhotoTaking());
    final xFile = await imagePicker.pickImage(source: ImageSource.camera);
    print(xFile!.path);

    emit(PhotoToked());
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            Image.file(File(xFile.path)).image);
    rgbColorChanged(
      paletteGenerator.colors.first.red,
      paletteGenerator.colors.first.green,
      paletteGenerator.colors.first.green,
    );
  }

  List<dynamic>? ldrValues;
  String? json;

  int itemCount = 60;
  List<double> data = [];
  List<String> time = [];

  Future getJson() async {
    emit(JsonGet());
    var url = Uri.parse(
        "https://script.googleusercontent.com/macros/echo?user_content_key=AzV2E5t0_nErlSxJM-LT2DpwvOuxLOmetGvl8eAQMH6xucI36CqN7N0ZG12mY_bZ48y8Y1NVMrZNRVY0MXRDmKdd1T7ToMjym5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnAG_t5JAlCBYh-4pzFuo0hYylFyXMGeacPvHeSyhPRMZEZkQ5vpwvq4snJvFGrWJT3jeEKenHH9lcJhMnYxoaSFlBLShXJG4bw&lib=M_MTsbg1Oc4iS5ELx-TpVngHKiz3AQw03");
    json = await http.read(url).then((value) {
      ldrValues = jsonDecode(value);
      print(ldrValues);

      itemCount = ldrValues!.length < 60 ? ldrValues!.length : 60;
      var dataUsed = ldrValues!.sublist(0, itemCount);
      data = [];
      time = [];
      dataUsed.forEach((element) {
        data.add((element['value'].toDouble()) / 100);
        time.add(element['date'].split('T')[1].substring(0, 5));
      });
      emit(JsonGot());
      return value;
    });
  }
}
