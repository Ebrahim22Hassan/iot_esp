import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AAAAAAA"),
        backgroundColor: Colors.red,
        actions: [
          ElevatedButton(
              onPressed: () {
                print("SASDSDSDSDS");
              },
              child: Text('TD '))
        ],
      ),
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
