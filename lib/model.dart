import 'dart:convert';
import 'package:http/http.dart' as http;

class DbConnect {
  final url =
      Uri.parse('https://flutter-iot-esp-default-rtdb.firebaseio.com/esp.json');

  ///To get/fetch questions from database
  Future fetchData() async {
    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      data.forEach((key, value) {
        print("key: $key , value: $value");
      });
    });
  }
}
